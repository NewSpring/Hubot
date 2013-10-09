# Description: 
#   Generates help commands for Hubot.
#
# Commands:
#   apollos who are you? - Tells where Apollos came from.
#
#

module.exports = (robot) ->
  robot.respond /who are you\?$/i, (msg) ->
    msg.reply "You should probably read this: https://www.bible.com/bible/111/act.18.24-27.niv"
  robot.enter (msg) ->
    user = '21097_102109@chat.hipchat.com'
    unless msg.message.user == user
      msg.send user, "Remember, beoptimistic.cc!"
