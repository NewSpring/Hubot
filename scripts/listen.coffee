# Description:
#   None
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   goodmorning @bron - Dance the day away
#
# Author:
#   jbaxleyiii

module.exports = (robot) ->
  robot.hear /donut/i, (msg) ->
    msg.send "http://ns.ops.s3.amazonaws.com/hubot/donut.gif"

  robot.hear /corndog/i, (msg) ->
    msg.send "http://ns.ops.s3.amazonaws.com/hubot/corndog.gif"

  robot.hear /goodbye \@erin/i, (msg) ->
    msg.send "http://ns.ops.s3.amazonaws.com/hubot/erin.gif"

  robot.hear /cmay/i, (msg) ->
    msg.send "http://ns.ops.s3.amazonaws.com/hubot/cmay.jpg"
