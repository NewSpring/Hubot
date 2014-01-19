# Description:
#   NewSpring Script is Just a collection of Scripts to assist in design of NewSpring
#
# Commands:
#   hubot ns colors, Returns color Hex Values
#

module.exports = (robot) ->
  robot.respond /(newspring|ns) colors/i, (msg) ->
    msg.send "Primary: #6BAC43, R: 107, G: 172, B: 67"
    msg.send "Green 1: #518933, R: 81, G: 137, B: 51"
    msg.send "Green 2: #3C6E26, R: 60, G: 110, B: 38"
    msg.send "Black:   #282828, R: 40, G: 40, B: 40"
