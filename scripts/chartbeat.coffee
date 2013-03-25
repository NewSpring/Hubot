# Description:
#   Display current app performance stats from New Relic
#
# Dependencies:
#   "xml2js": "0.2.0"
#
# Configuration:
#   HUBOT_CHARTBEAT_SITE
#   HUBOT_CHARTBEAT_API_KEY
# 
# Commands:
#   hubot chart me (path) - Returns active concurrent vistors from the site 
#   specified.
#
# Notes:
#   How to find these settings:
#   Log into chartbeat then browse to 
#   http://chartbeat.com/docs/api/explore
# 
# Author:
#   Drew Delianides

module.exports = (robot) ->
  robot.respond /chart( me)? (.*)/i, (msg) ->
    site = if (msg.match[2] == 'me') then process.env.HUBOT_CHARTBEAT_SITE else msg.match[2]
    apiKey = process.env.HUBOT_CHARTBEAT_API_KEY
    Parser = require("xml2js").Parser
    msg.http("http://api.chartbeat.com/live/quickstats/v3/?apikey=#{apiKey}&host=#{site}")
      .get() (err, res, body) ->
        unless res.statusCode is 200
         msg.send "There was a problem with Chartbeat. Do you have access to this domain?"
         return

        response = JSON.parse(body)
        people = response.people || []
        pluralize = if (people == 1) then "person" else "people"
        msg.send "I see #{people} #{pluralize} on #{site} right now!"

