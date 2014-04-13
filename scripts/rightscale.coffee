# Description:
#   Rightscale integrates with the Rightscale API v1.5. Currently it only pulls information,
#   but eventually I would like it to manage instances, arrays or deployments all from hubot.
#   Can also accept a POST request to the hubot instance at /apollos/rightscale
#
# Commands:
#   hubot rs deploy [env] [branch], Update Application Code (requires 'deploy' role)
#   hubot rs reboot apache [instance], Reboots Apache Web Server on Array or Instances Specified. (requires 'deploy' role)
#   hubot rs rollback [env], Required to specify an environment.
#   hubot rightscale [endpoint], Runs a request against the api and outputs the JSON response.
#
url         = require 'url'
querystring = require 'querystring'
Table       = require 'cli-table'
util        = require('util')
_           = require("underscore")


auth = process.env.RIGHTSCALE_API_ENDPOINT
token = process.env.RIGHTSCALE_API_TOKEN
dev_array = process.env.RIGHTSCALE_DEV_ARRAY
prod_array = process.env.RIGHTSCALE_PROD_ARRAY

base = "https://us-4.rightscale.com/api/"

module.exports = (robot) ->
  robot.router.post "/apollos/rightscale", (req, res) ->
    robot.messageRoom req.body.room, req.body.body
    res.end "ok"

  robot.respond /rs deploy ?(.*)/i, (msg) ->
    if robot.auth.hasRole(msg.envelope.user,'deploy') is true
      vars = msg.match[1].split(" ")
      env = vars[0]
      branch = vars[1] || "develop"

      unless (url_api_base = process.env.HUBOT_GITHUB_API)?
        url_api_base = "https://api.github.com"

      github = require("githubot")(robot)
      github.qualified_repo process.env.HUBOT_GITHUB_REPO || "NewSpring"

      github.handleErrors (response) ->
        msg.send "Github Error: #{response.statusCode} #{response.error}"
        return false

      github.get "#{url_api_base}/repos/NewSpring/NewSpring/branches", (branches) ->
        names = _.pluck(branches, "name")
        if _.contains(names, "#{branch}") is true
          if env is "prod" or env is "production"
            unless branch is "master" or branch is "develop"
              msg.send "You can only deploy master to production."
              return false
            branch = "master"
            env = "production"
            array = prod_array
          else if env is "stag" or env is "staging" or env is "dev"
            if branch is "master"
              msg.reply "You cannot deploy master to the staging array. Choose a different branch or leave blank to deploy the develop branch."
              return false
            array = dev_array
            env = "staging"

          request = "server_arrays/#{array}/multi_run_executable"
          execute = querystring.stringify({"recipe_name": "expressionengine::update", "inputs[][name]":"ee/update_revision", "inputs[][value]":"#{branch}"})
          rightscale(token, auth, msg, request, execute)
          msg.reply "OK, deploying #{branch} on #{env}..."
        else
          msg.send "Check your spelling. That branch is not on Github."
          return false
    else
      msg.reply "Sorry, You must have 'deploy' access to for me update the site."


  robot.respond /rs reboot apache ?(.*)/i, (msg) ->
    console.log(msg.envelope.user)
    if robot.auth.hasRole(msg.envelope.user,'deploy') is true
      instance = msg.match[1]
      unless instance is ""
        msg.reply "Ok, I'll reboot apache for you."
        request = "server_arrays/#{array}/multi_run_executable"
        execute = querystring.stringify({'recipe_name': 'expressionengine::do_reboot_apache'})
        #rightscale(token, auth, msg, request, execute)
      else
        msg.reply "Sorry, I don't know how to reboot individual servers yet."
        #execute = querystring.stringify({'recipe_name': 'main::do_reboot_apache'})
        #rightscale(token, auth, msg, request, execute)
    else
      msg.reply "Sorry, You must have 'deploy' access for me to reboot apache."

  robot.respond /rs rollback ?(.*)/i, (msg) ->
    if robot.auth.hasRole(msg.envelope.user,'deploy') is true
      instance = msg.match[1]
      unless instance is ""
        if instance == "prod" or instance == "production"
          msg.reply "Ok, Rolling back production array to previous release..."
          request = "server_arrays/#{prod_array}/multi_run_executable"
          execute = querystring.stringify({'recipe_name': 'expressionengine::rollback'})
          rightscale(token, auth, msg, request, execute)
        else if instance == "stag" or instance == "staging" or instance == "dev"
          msg.reply "Ok, Rolling back staging array to previous release..."
          request = "server_arrays/#{dev_array}/multi_run_executable"
          execute = querystring.stringify({'recipe_name': 'expressionengine::rollback'})
          rightscale(token, auth, msg, request, execute)
        else
          msg.reply "I'm not sure which environment I should rollback?"
      else
        msg.reply "Which environment should I rollback?"
    else
      msg.reply "Sorry, You must have 'deploy' access for me to rollback a release."


processResponse = (err, res, body, msg) ->
  switch res.statusCode
    when 202
      msg.send "Rightscale has been instructed to deploy...please wait."
    when 404
      msg.send "There was an error! #{body}, #{err}"
    when 401
      msg.send "There was an authentication error!, #{err}"
    else
      msg.send "Status: #{res.statusCode}, I was unable to process your request, #{body}, #{err}"

rightscale = (token, auth, msg, request, execute = null, method = "post") ->
  msg.robot.http("#{auth}?grant_type=refresh_token&refresh_token=#{token}")
    .headers("X-API-Version": "1.5", "Content-Length": '0')
    .post() (err, res, data) ->
      unless res.statusCode is 200
        msg.send "There is a problem with RightScale. #{data}"
        return false
      response = JSON.parse(data)
      access = response.access_token

      if method == "post"
        msg.robot.http("#{base}#{request}.json")
          .headers(Authorization: "Bearer #{access}", "X-API-Version": "1.5", "Content-Length": "0")
          .post(execute) (err, res, body) ->
            processResponse(err, res, body, msg)
      else
        msg.robot.http("#{base}#{request}.json")
          .headers(Authorization: "Bearer #{access}", "X-API-Version": "1.5", "Content-Length": "0")
          .get() (err, res, body) ->
            unless res.statusCode is 200
              processResponse(err, res, body, msg)
            else
              try
                instances = JSON.parse(body)
                parseInstances(instances, msg)
              catch error
                msg.send "Uh oh, I have no idea what Rightscale just sent back!"
