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
  "https://s3.amazonaws.com/ns.backup/development/Proof_Hammer.png",
]

module.exports = (robot) ->
  robot.hear /proof it\b/i, (msg) ->
    msg.send msg.random proofs
