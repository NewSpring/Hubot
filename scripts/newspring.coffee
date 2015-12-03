# Description:
#   NewSpring Script is Just a collection of Scripts to assist in design of NewSpring
#
# Commands:
#   hubot ns colors, Returns color Hex Values
#

Table = require "cli-table"

module.exports = (robot) ->
  robot.respond /(newspring|ns) colors/i, (msg) ->
    table = new Table({head: ['Green', 'Hex', 'RGB'], style: { head:[], border:[], 'padding-left':1, 'padding-right':1 }})
    table.push ( ["Primary","#6BAC43", "107,172,67"] )
    table.push ( ["Secondary","#1c683e","28/104/62"] )
    table.push ( [ "Tertiary","#2a4930","60,110,38"] )
    msg.send "/quote " + table.toString()

    table = new Table({head: ['Black', 'Hex', 'RGB'], style: { head:[], border:[], 'padding-left':1, 'padding-right':1 }})
    table.push ( [ "Primary","#303030","48,48,48"] )
    table.push ( [ "Secondary","#858585","133,133,133"] )
    table.push ( [ "Tertiary","#dddddd","221,221,221"] )
    msg.send "```\n" + table.toString() + "\n```"

