# Description:
#   Event system related utilities
#
# Commands:
#  follow the sequence from Jurassic Park
#
module.exports = (robot) ->
  robot.hear /(access security)/i, (msg) ->
    msg.send "/quote access: PERMISSION DENIED."

  robot.hear /access main security grid/i, (msg) ->
    msg.send "/quote access: PERMISSION DENIED....and..."
    magicWord = setInterval () ->
      msg.send "/quote YOU DIDN'T SAY THE MAGIC WORD!"
    , 150
    msg.send "http://25.media.tumblr.com/8566ef54aefe210f0706b8768a62ff5c/tumblr_mh38zhM4vs1qj1te0o1_400.gif"

  robot.hear /shutdown the system/i, (msg) ->
    if magicWord
      msg.send "Hold on to your butts..."
      clearInterval(magicWord)
      magicWord = null
    else
      msg.send "System Ready."

