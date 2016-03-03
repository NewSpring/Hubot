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
  robot.hear /morning \@bron/i, (msg) ->
    msg.send "http://ns.ops.s3.amazonaws.com/hubot/bron.gif"

  robot.hear /goodbye \@erin/i, (msg) ->
    msg.send "http://ns.ops.s3.amazonaws.com/hubot/erin.gif"
    
  robot.hear /cmay/i, (msg) ->
    msg.send "http://ns.ops.s3.amazonaws.com/hubot/cmay-forever.jpg"
