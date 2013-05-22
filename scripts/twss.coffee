# Description:
#   Hubot will respond to (in)appropriate lines with "That's what she said"
#
# Dependencies:
#   None
#
# Configuration:
#   
#
# Commands:
#   hubot <anything related to size, speed, quality, specific body parts> - Hubot will "that's what she said" that ish
#
# Author:
#   dhchow

module.exports = (robot) ->
  robot.respond /.*(too big|too small|too long|too hard|too soft|too wet|too dry|too good|too fast|too slow|already did it|already did that|long and hard|is huge|was huge|put it away|put that away||on top of it|on top of that|put it in there|put it on there|put it in that|put it on that|put it on the|put it in the|put it all in|fit that|fit it|too hot|really hot|jump on it|huge|suck|blow)/i, (msg) ->
    msg.send "That's what she said!"
