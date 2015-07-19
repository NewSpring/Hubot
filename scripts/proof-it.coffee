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
#   it's a trap - Display an Admiral Ackbar piece of wonder
#
# Author:
#   brilliantfantastic

proofs = [
  "https://lifegivingwater.files.wordpress.com/2013/01/hammertime.gif",
]

module.exports = (robot) ->
  robot.hear /proof it\b/i, (msg) ->
    msg.send msg.random proofs
