# Description:
#   NewSpring Script is Just a collection of Scripts to assist in design of NewSpring
#
# Commands:
#   hubot ns colors, Returns color Hex Values
#

module.exports = (robot) ->
  robot.respond /(newspring|ns) colors/i, (msg) ->
    msg.send "Primary: #6BAC43, RGB: 107,172,67, CMYK: 25.49, 0, 41.18, 32.55"
    msg.send "Green 1: #518933, RGB: 81,137,51, CMYK: 21.96, 0, 33.73, 46.27"
    msg.send "Green 2: #3C6E26, RGB: 60,110,38, CMYK: 19.61, 0, 28.24, 56.86"
    msg.send "Black:   #282828, RGB: 40,40,40, CMYK: 0,0,0,84.31"
