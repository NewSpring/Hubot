# Description: 
#   Generates help commands for Hubot.
#
# Commands:
#   apollos who are you? - Tells where Apollos came from.
#
#

module.exports = (robot) ->
  robot.respond /who are you\?$/i, (msg) ->
    msg.reply "You should probably reade this: https://www.bible.com/bible/111/act.18.24-27.niv"
