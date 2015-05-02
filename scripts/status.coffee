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

module.exports = (robot) ->
  robot.respond /status reset/i, (msg) ->
    spark.login({accessToken: process.env.SPARK_API_TOKEN}).then(
      console.log spark.devices
      spark.getDevice(process.env.SPARK_DEVICE_ID, (err, device) ->
        device.callFunction('setStatus', 'success', (err, data) ->
          if (err)
            console.error "Error setting status!"
        )
      )
    )

  robot.router.post '/hubot/status/set', (req, res) ->
    room = process.env.SPARK_STATUS_ROOM
    status = req.body.payload.status
    console.log status
    failCount = robot.brain.get('failCount')
    console.log "Current FailCount: " + failCount
# if status is building then set appropriate light
    switch status
      when 'running','queued','scheduled' then setStatus 'building'
      when 'success','fixed' then failCount-- unless failCount == 0
      when 'failed','infrastructure_fail','timedout' then failCount++

    if failCount == 0
      setStatus('success')
    if failCount > 0
      setStatus('failed')

    robot.brain.set 'failCount', failCount

    res.writeHead 200, {'Content-Type': 'text/plain' }
    res.end 'Thanks\n'

setStatus = (status) ->
  spark.login({accessToken: process.env.SPARK_API_TOKEN}).then(
    console.log spark.devices
    spark.getDevice(process.env.SPARK_DEVICE_ID, (err, device) ->
      device.callFunction('setStatus', status, (err, data) ->
        if (err)
          console.error "Error setting status!"
      )
    )
  )



