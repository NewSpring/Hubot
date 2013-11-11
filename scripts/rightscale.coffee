# Description:
#   Rightscale integrates with the Rightscale API v1.5. Currently it only pulls information,
#   but eventually I would like it to manage instances, arrays or deployments all from hubot.
#
# Commands:
#   hubot rs instances, Returns information about Rightscale Instances
#   hubot rs arrays, Returns information about Rightscale Arrays
#
# Todo:
#   Set to Grow Array
#   Set to Shrink Array
#   Reboot Apache
#   Update Array
#

url = require 'url'
querystring = require 'querystring'

kraken = [
  "http://sd.keepcalm-o-matic.co.uk/i/keep-calm-and-release-the-kraken-12.png",
  "http://images.wikia.com/potcoplayers/images/9/9b/Release-the-kraken.jpg",
  "http://images.cheezburger.com/completestore/2010/4/4/129149063829780331.jpg",
  "http://iwanticewater.files.wordpress.com/2013/04/release-the-kraken-07.jpg?w=425&h=319",
  "http://ct.fra.bz/ol/fz/sw/i55/5/4/16/frabz-ONE-DOES-NOT-SIMPLY-RELEASE-THE-KRAKEN-03d8b2.jpg",
  "http://i.imgur.com/PFJqA.gif",
  "https://i.chzbgr.com/maxW500/3856985856/hA452FE76.gif",
  "http://2.bp.blogspot.com/_EBmpqCL3evc/S6mUc9g7zQI/AAAAAAAADmE/KpG-INWpjO8/s400/release-the-kraken-seal.jpg",
  "http://winningateverything.com/files/2012/05/WA_flasking.jpg",
  "http://www.quickmeme.com/img/26/26f068bfb19d27a5babc9574e9a6c8a12cc0b8e35757c4e26ee3db93e109f186.jpg"
]

auth = process.env.RIGHTSCALE_API_ENDPOINT
token = process.env.RIGHTSCALE_API_TOKEN
array = process.env.RIGHTSCALE_ARRAY

base = "https://my.rightscale.com/api/"

module.exports = (robot) ->
  robot.router.post "/apollos/rightscale", (req, res) ->
    robot.messageRoom req.body.room, req.body.body
    res.end "ok"

  robot.respond /release the kraken/i, (msg) ->
    if isAdmin
      #request = "server_arrays/#{array}/multi_run_executable"
      #execute = querystring.stringify({'recipe_name': 'expressionengine::update'})
      #rightscale(token, auth, msg, request, execute)
      msg.send msg.random kraken
    else
      msg.send "You must be an admin to run this function"

  robot.respond /rs show firewall/i, (msg) ->
    request = "server_arrays/#{array}/multi_run_executable"
    execute = querystring.stringify({'recipe_name': 'sys_firewall::do_list_rules'})
    rightscale(token, auth, msg, request, execute)

  robot.respond /rs reboot apache/i, (msg) ->
    request = "server_arrays/#{array}/multi_run_executable"
    execute = querystring.stringify({'recipe_name': 'main::do_reboot_apache'})
    rightscale(token, auth, msg, request, execute)

  robot.respond /rs array/i, (msg) ->
    request = msg.match[1]
    rightscale(token, auth, msg, request)

isAdmin = () ->
  robot.auth.hasRole(msg.envelope.user,'admin')

rightscale = (token, auth, msg, request, execute = null) ->
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
        .post(execute) (err, res, body) ->
          switch res.statusCode
            when 200
              msg.send "#{body}"
            when 202
              msg.send "Running Script, Rightscale should report back results."
            when 404
              msg.send "There was an error! #{body}"
            when 401
              msg.send "There was an authentication error!"
            else
              msg.send "Status: #{res.statusCode}, I was unable to process your request, #{body}"




