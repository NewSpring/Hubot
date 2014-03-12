# Description:
#   Rackspace is a cloud hosting company. This script is to output various information
#   from their API.
#
# Commands:
#   hubot rack servers, Return table of the servers in Rackspace.
#   hubot rack clb, Returns table of information about the load balancers
#   hubot rack dns [domain], Returns information about the specified DNS entry in rackspace.
#

url = require "url"
querystring = require "querystring"
Table = require "cli-table"
util = require "util"
pkgcloud = require "pkgcloud"
moment = require "moment"

rackspace = {
    provider: 'rackspace',
    username: process.env.RACKSPACE_USERNAME,
    apiKey: process.env.RACKSPACE_API,
    region: process.env.RACKSPACE_REGION
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
          publicIp = server.original.accessIPv4 || 'Not Set'
          privateIp = server.addresses.private[0].addr || 'Not Set'
          now = moment()
          since = now.from(server.original.created, true)
          table.push(
           ["#{server.name}", "#{publicIp}", "#{privateIp}", "#{since}"]
          )
        msg.send "/quote " + table.toString()
    )

  robot.respond /rack clb/i, (msg) ->
    client = pkgcloud.loadbalancer.createClient(rackspace)
    client.getLoadBalancers((err, loadbalancers) ->
      if(err)
        msg.send err
      else
        table = new Table({head: ['Name', 'Protocol', 'Port', 'Public IP', 'Nodes'], style: { head:[], border:[], 'padding-left': 1, 'padding-right': 1 }})
        for lbs in loadbalancers
          table.push(
           ["#{lbs.name}", "#{lbs.protocol}", "#{lbs.port}", "#{lbs.virtualIps[0].address}", "#{lbs.nodeCount}"]
          )
        msg.send "/quote " + table.toString()
    )

  robot.respond /rack dns (.*)/i, (msg) ->
    domain = escape(msg.match[1])
    client = pkgcloud.dns.createClient(rackspace)
    details = {name: domain}
    client.getZones(details, (err, zones) ->
      if(err)
        msg.send err
      else
        if (zones.length < 1)
          msg.send "I didn't find that domain at Rackspace!"
          return false

        client.getRecords(zones[0].id,( err, records) ->
          if(err)
            msg.send err
          else
            table = new Table({head: ['Name', 'Type', 'Data', 'TTL'], style: { head:[], border:[], 'padding-left': 1, 'padding-right': 1 }})
            for record in records
              table.push(
               ["#{record.name}", "#{record.type}", "#{record.data}", "#{moment.duration((record.ttl/60), "minutes" ).humanize()}"]
              )
            msg.send "/quote " + table.toString()
        )
    )


