# Description:
#   Rightscale integrates with the Rightscale API v1.5. Currently it only pulls information,
#   but eventually I would like it to manage instances, arrays or deployments all from hubot.
#   Can also accept a POST request to the hubot instance at /rightscale
#
# Commands:
#   hubot rs deploy [env] [branch], Update Application Code (requires 'deploy' role)
#
# Hooks:
#   /rightscale/deploy - initiate a deploy
#   /rightscale/report - after a deploy finished
#

url         = require 'url'
querystring = require 'querystring'
util        = require('util')
_           = require("underscore")

auth = process.env.RIGHTSCALE_API_ENDPOINT
token = process.env.RIGHTSCALE_API_TOKEN
dev_array = process.env.RIGHTSCALE_DEV_ARRAY
prod_array = process.env.RIGHTSCALE_PROD_ARRAY
beta_array = process.env.RIGHTSCALE_BETA_ARRAY
post_token = process.env.RIGHTSCALE_POST_TOKEN
room = process.env.HUBOT_OPS_ROOM
base = "https://us-4.rightscale.com/api/"

module.exports = (robot) ->
  robot.router.post "/rightscale/report", (req, res) ->
    data     = if req.body.payload? then JSON.parse req.body.payload else req.body
    room     = data.room
    fallback = data.fallback

    fields = [
      {
        title: "Instance ID"
        value: data.instance_id
        short: true
      }
      {
        title: "IP Address"
        value: data.public_ip
        short: true
      }
    ]

    if data.short isnt true
      long = [
        {
          title: "Instance Type"
          value: data.type
          short: true
        }
        {
          title: "Local Hostname"
          value: data.local_hostname
          short: true
        }
        {
          title: "Local IP Address"
          value: data.local_ip
          short: true
        }
        {
          title: "Public Hostname"
          value: data.public_hostname
          short: true
        }
        {
          title: "Availability Zone"
          value: data.zone
          short: true
        }
      ]
      fields = fields.concat(long)

    if data.revison?
      deployment = [
        {
          title: "Revision"
          value: data.revision
          short: true
        }
      ]
      fields = fields.concat(deployment)

    console.log "hello"

    if process.env.HUBOT_SLACK_INCOMING_WEBHOOK?
      robot.emit 'slack.attachment',
        fallback: fallback
        channel: room
        icon_url: "http://ns.ops.s3.amazonaws.com/images/rightscale.png"
        username: "Rightscale"
        content:
          color: "good"
          title: "Rightscale"
          text: data.text
          fields: fields
    else
      robot.messageRoom room, fallback
    res.end 'OK'

  robot.router.post '/rightscale/deploy', (req, res) ->
    data   = if req.body.payload? then JSON.parse req.body.payload else req.body
    room   = data.room
    if data.token = post_token
      request = "server_arrays/#{data.array}/multi_run_executable"
      execute = querystring.stringify({"recipe_name": "noah::do_deploy_newspring_cc", "inputs[][name]":"noah/revision", "inputs[][value]":"#{data.branch}"})
      fallback = "Starting deployment of #{data.branch} to #{data.env}"

      if process.env.HUBOT_SLACK_INCOMING_WEBHOOK?
        robot.emit 'slack.attachment',
          fallback: fallback
          channel: room
          icon_url: "http://ns.ops.s3.amazonaws.com/images/rightscale.png"
          username: "Rightscale"
          content:
            color: "warning"
            pretext: "Rightscale has been instructed to deploy!"
            fields: [
              {
                title: "Environment"
                value: data.env
                short: true
              }
              {
                title: "Branch"
                value: data.branch
                short: true
              }
            ]
      else
        robot.messageRoom room, fallback
      rightscale(token, auth, request, execute, data.room, robot)
      res.end "OK"
    else
      res.end 'Forbidden'

  robot.respond /rs deploy ?(.*)/i, (msg) ->
    room = process.env.RIGHTSCALE_NOTIFY_ROOM
    if robot.auth.isAdmin(msg.message.user) is true
      vars = msg.match[1].split(" ")
      env = vars[0]
      branch = vars[1] || "develop"

      unless (url_api_base = process.env.HUBOT_GITHUB_API)?
        url_api_base = "https://api.github.com"

      github = require("githubot")(robot)
      github.qualified_repo process.env.HUBOT_GITHUB_REPO || "NewSpring"

      github.handleErrors (response) ->
        msg.send "Github Error: #{response.error}"
        return false

      github.get "#{url_api_base}/repos/NewSpring/NewSpring/branches/#{branch}", (b) ->
          if env is "prod" or env is "production"
            unless branch is "master" or branch is "alpha"
              msg.send "You can only deploy master to production."
              return false
            branch = "master"
            env = "production"
            array = prod_array
          else if env is "beta"
            array = beta_array
          else if env is "stag" or env is "staging" or env is "dev"
            if branch is "master"
              msg.reply "You cannot deploy master to the staging array. Choose a different branch or leave blank to deploy the alpha branch."
              return false
            array = dev_array
            env = "alpha"

          request = "server_arrays/#{array}/multi_run_executable"
          execute = querystring.stringify({"recipe_name": "noah::do_deploy_newspring_cc", "inputs[][name]":"noah/revision", "inputs[][value]":"#{branch}"})
          rightscale(token, auth, request, execute, room, robot)
          msg.reply "OK, deploying #{branch} on #{env}..."
    else
      msg.reply "Sorry, You must have 'admin' access to for me update the site."

  robot.respond /rs rollback ?(.*)/i, (msg) ->
    room = msg.envelope.room
    if robot.auth.isAdmin(msg.message.user) is true
      instance = msg.match[1]
      unless instance is ""
        if instance == "prod" or instance == "production"
          msg.reply "Ok, Rolling back production array to previous release..."
          request = "server_arrays/#{prod_array}/multi_run_executable"
          execute = querystring.stringify({'recipe_name': 'noah::do_rollback_newspring_cc', "input[][name]":"noah/slack/channel", "inputs[][value]": "#{room}"})
          rightscale(token, auth, request, execute, room, robot)
        else if instance == "stag" or instance == "staging" or instance == "dev" or instance == "beta"
          msg.reply "Ok, Rolling back staging array to previous release..."
          request = "server_arrays/#{beta_array}/multi_run_executable"
          execute = querystring.stringify({'recipe_name': 'noah::do_rollback_newspring_cc', "input[][name]":"noah/slack/channel", "inputs[][value]": "#{room}"})
          rightscale(token, auth, request, execute, room, robot)
        else
          msg.reply "I'm not sure which environment I should rollback?"
      else
        msg.reply "Which environment should I rollback?"
    else
      msg.reply "Sorry, You must have 'admin' access for me to rollback a release."

  robot.respond /rs restart (apache|varnish)/i, (msg) ->
    service = msg.match[1]
    # make sure this responds back into the same room it was requested from
    room = msg.envelope.room
    if robot.auth.isAdmin(msg.envelope.user) is true
      request = "server_arrays/#{prod_array}/multi_run_executable"
      execute = querystring.stringify({'recipe_name': "noah::do_restart_#{service}", "inputs[][name]":"noah/slack/channel", "inputs[][value]":"#{room}"})
      rightscale(token, auth, request, execute, room, robot)
    else
      msg.reply "Sorry, You must have 'admin' access for me to restart the #{service} service."

rightscale = (token, auth, request, execute = null, room, robot) ->
  robot.http("#{auth}?grant_type=refresh_token&refresh_token=#{token}")
    .headers("X-API-Version": "1.5", "Content-Length": '0')
    .post() (err, res, data) ->
      console.error err
      response = JSON.parse(data)
      access = response.access_token
      console.log access
      robot.http("#{base}#{request}.json")
        .headers(Authorization: "Bearer #{access}", "X-API-Version": "1.5", "Content-Length": "0")
        .post(execute) (err, res, body) ->
          if err?
            console.error err
          switch res.statusCode
            when 200
              robot.messageRoom room, "Ok, I'm sending your request to Rightscale."
            when 404
              robot.messageRoom room, "There was an error! #{body}, #{err}"
            when 401
              robot.messageRoom room, "There was an authentication error!, #{err}"
            when 500
              robot.messageRoom room, "Status: #{res.statusCode}, I was unable to process your request, #{body}, #{err}"

