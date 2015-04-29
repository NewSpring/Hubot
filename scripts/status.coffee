# Description:
#    Accepts a POST request via webhook from the twillio service.
#
#  Dependencies:
#    "spark": "0.4.2"
#
#  Configuration:
#    SPARK_API_TOKEN
#    SPARK_DEVICE_ID
#
#  Commands:
#    hubot status reset, clears status lights back to green
#
#  URLs:
#    POST /hubot/status/set
#
#  Author:
#    delianides
#
#

spark = require('spark')
spark.login({accessToken: process.env.SPARK_API_TOKEN})

statusLight = spark.getDevice(process.env.SPARK_DEVICE_ID, (err, device) ->
  console.log "Found StopLight"
)

module.exports = (robot) ->
  robot.respond /status reset/i, (msg) ->
    statusLight.callFunction('setStatus','success', (err, data) ->
      if (err)
        console.log "Error setting status!"
    )

  robot.router.post '/hubot/status/set', (req, res) ->
    room = process.env.SPARK_STATUS_ROOM
    console.log req.body
    # status = req.payload.status

    # console.log status



