# Description:
#   Rightscale integrates with the Rightscale API v1.5. Currently it only pulls information,
#   but eventually I would like it to manage instances, arrays or deployments all from hubot.
#
# Commands:
#   hubot rs instances, Returns information about Rightscale Instances
#   hubot rs arrays, Returns information about Rightscale Arrays
#

_ = require 'underscore'
auth = process.env.RIGHTSCALE_API_ENDPOINT
token = process.env.RIGHTSCALE_API_TOKEN
base = "https://my.rightscale.com/api/"


module.exports = (robot) ->
  robot.router.post 'apollos/rightscale', (req, res) ->
    query = querystring.parse url.parse(req.url).query
    res.end JSON.stringify {
      received: true
    }
    user = {}
    user.room = query.room if query.room
    payload = JSON.parse req.body.payload
    robot.send user, "#{paylod.message}"

  robot.respond /rs (.*)/i, (msg) ->
    request = msg.match[1]
    rightscale(token, auth, msg, request)

rightscale = (token, auth, msg, request) ->
  msg.robot.http("#{auth}?grant_type=refresh_token&refresh_token=#{token}")
    .headers("X-API-Version": "1.5", "Content-Length": '0')
    .post() (err, res, data) ->
      unless res.statusCode is 200
        msg.send "There is a problem with RightScale. #{data}"
        return false
      response = JSON.parse(data)
      access = response.access_token

      msg.robot.http("#{base}#{request}")
        .headers(Authorization: "Bearer #{access}", "X-API-Version": "1.5", "Content-Length": "0")
        .get() (err, res, data) ->
          switch res.statusCode
            when 200
              msg.send "#{data}"
            when 404
              msg.send "There was an error!"
            when 401
              msg.send "There was an authentication error!"
            else
              msg.send "I was unable to process your request, #{data}"




