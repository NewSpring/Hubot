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
jsdom = require("jsdom").jsdom

module.exports = (robot) ->
  robot.respond /http error (\d{3})/i, (msg) ->
    msg.send "Looking..."
    error = msg.match[1]
    msg
      .http('http://en.wikipedia.org/wiki/List_of_HTTP_status_codes')
      .get() (err, res, body) ->
        window = (jsdom body, null,
          features :
            FetchExternalResources : false
            ProcressExternalResources : false
            MutationEvents : false
            QuerySelector : false
        ).createWindow()

        $ = require('jquery').create(window)

        statusCode = $('#'+error).parent().text()
        if statusCode
          msg.send statusCode
          msg.send "http://en.wikipedia.org/wiki/List_of_HTTP_status_codes##{error}"
        else
          msg.send "Error Code #{error} doesn't exist. Ironically, this would be HTTP Error 404"
