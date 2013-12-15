# Description:
#   Rackspace is a cloud hosting company. This script is to output various information
#   from their API.
#
# Commands:
#   hubot rack servers, Return table of the servers in Rackspace.
#   hubot rack databases, Returns table of information about the Databases // Not Implemented
#   hubot rack loadbalancerss, Returns table of information about the load balancers
#
#

url = require "url"
querystring = require "querystring"
Table = require "cli-table"
util = require "util"
pkgcloud = require "pkgcloud"
moment = require "moment"

rackspace = {
    provider: 'rackspace',
    username: 'newspringchurch',
    apiKey: 'ecccd27c5febf908280b7c0e0cf2aa9d'
    region: 'ORD'
}

module.exports = (robot) ->
  robot.respond /rack servers/i, (msg) ->
    client = pkgcloud.compute.createClient(rackspace)
    client.getServers((err, servers) ->
      if(err)
        msg.send err
      else
        table = new Table({head: ['Name', 'Public IP', 'Private IP', 'Age'], style: { head:[], border:[], 'padding-left': 1, 'padding-right': 1 }})
        for server in servers
          # console.log(util.inspect(server, false, null))
          publicIp = server.original.accessIPv4 || 'Not Set'
          privateIp = server.addresses.private[0].addr || 'Not Set'
          now = moment()
          since = now.from(server.original.created, true)
          table.push(
           ["#{server.name}", "#{publicIp}", "#{privateIp}", "#{since}"]
          )
        msg.send "/quote " + table.toString()
    )

  robot.respond /rack loadbalancers/i, (msg) ->
    client = pkgcloud.loadbalancer.createClient(rackspace)
    client.getLoadBalancers((err, loadbalancers) ->
      if(err)
        msg.send err
      else
        table = new Table({head: ['Name', 'Protocol', 'Port', 'Public IP', 'Nodes'], style: { head:[], border:[], 'padding-left': 1, 'padding-right': 1 }})
        for lbs in loadbalancers
          #console.log(util.inspect(lbs, false, null))
          table.push(
           ["#{lbs.name}", "#{lbs.protocol}", "#{lbs.port}", "#{lbs.virtualIps[0].address}", "#{lbs.nodeCount}"]
          )
        msg.send "/quote " + table.toString()
    )

