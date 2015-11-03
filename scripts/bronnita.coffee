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

brons = [
  "https://s3.amazonaws.com/uploads.hipchat.com/21097/2655053/qnluc7wcHIRu4JL/bron.gif"
]

module.exports = (robot) ->
  robot.hear /morning \@bron/i, (msg) ->
    msg.send msg.random brons
