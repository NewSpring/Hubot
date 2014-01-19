# Description:
#   NewSpring Script is Just a collection of Scripts to assist in design of NewSpring
#
# Commands:
#   hubot ns colors, Returns color Hex Values
#

Table = require "cli-table"

module.exports = (robot) ->
  robot.respond /(newspring|ns) colors/i, (msg) ->
    table = new Table({head: ['Color', 'Hex', 'RGB', 'CMYK'], style: { head:[], border:[], 'padding-left':1, 'padding-right':1 }})
    table.push ( ["Primary","#6BAC43", "107,172,67", "25.49, 0, 41.18, 32.55" ] )
    table.push ( ["Secondary","#518933","81,137,51,","21.96, 0, 33.73, 46.27" ] )
    table.push ( [ "Tertiary","#3C6E26","60,110,38","19.61, 0, 28.24, 56.86" ] )
    table.push ( [ "Black","#282828","40,40,40","0, 0, 0, 84.31" ] )
    msg.send "/quote " + table.toString()

