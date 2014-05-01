# Description:
#   Displays the description for the requested error code.
#
# Dependencies:
#   jsdom
#
# Configuration:
#   None
#
# Commands:
#   hubot http error <error number> (404)
#
# Author:
#   delianides
#
jsdom = require "jsdom"
jquery = 'http://ajax.googleapis.com/ajax/libs/jquery/2.0.2/jquery.min.js'

module.exports = (robot) ->
  robot.respond /http error (\d{3})/i, (msg) ->
    error = msg.match[1]
    msg
      .http('http://en.wikipedia.org/wiki/List_of_HTTP_status_codes')
      .get() (err, res, body) ->
        jsdom.env body, [jquery], (errors, window) ->
          statusCode = window.$('#'+error).parent().text()
          if statusCode
            msg.send statusCode
            msg.send "http://en.wikipedia.org/wiki/List_of_HTTP_status_codes##{error}"
          else
            msg.send "Error Code #{error} doesn't exist. Ironically, this would be HTTP Error 404"
