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
util        = require('util')
_           = require("underscore")
OoyalaApi      = require("node-ooyala-api-client")


key = process.env.OOYALA_API_KEY
secret = process.env.OOYALA_API_SECRET

module.exports = (robot) ->
  robot.respond /ooyala download ?(.*)/i, (msg) ->
    client = new OoyalaApi(key, secret)
    apiPath = "/assets/"+msg.match[1]+"/source_file_info"
    client.get(apiPath).then (data) ->
      msg.send "#{data.original_file_name} - #{data.source_file_url}"



