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
  robot.respond /chart me/i, (msg) ->
    site     = process.env.HUBOT_CHARTBEAT_SITE
    apiKey    = process.env.HUBOT_CHARTBEAT_API_KEY
    Parser = require("xml2js").Parser
    
    msg.http("http://api.chartbeat.com/live/quickstats/v3/?apikey=#{apiKey}&path=#{path}")
      .get() (err, res, body) ->
        if err
          msg.send "Chartbeat says: #{err}"
          return

        (new Parser).parseString body, (err, json)->
          people = json['people'] || []
                       
          msg.send "I see #{people} people on the site right now!"

