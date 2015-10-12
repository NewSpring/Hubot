# Description:
#   Returns download link from Ooyala Video Platform API
#
# Configuration:
#   OOYALA_API_KEY
#   OOYALA_API_SECRET
#
# Commands:
#   hubot ooyala download [content id]
#
# Note:
#   This script will work for most adapters exept hipchat because of this: http://cl.ly/dVZn
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



