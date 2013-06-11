# Description:
#   WebRequest is the most important thing in your life
#
# Commands:
#   hubot hears WR ####, Returns Entry #### From Wufoo 

##Include Underscore to parse response
_ = require 'underscore'

module.exports = (robot) ->
  robot.hear /(WR|wr)( (\d+))?/i, (msg) ->
    entry_id = msg.match[2]
    user = process.env.WUFOO_API_KEY
    pass = "newspring" #not used by the wufoo API
    msg.http("https://#{user}:#{pass}@newspring.wufoo.com/api/v3/forms/web-request/entries.json?Filter1=EntryId+Is_equal_to+#{entry_id}")
      .headers(Accept: 'application/json')
      .get() (err, res, body) ->
        switch res.statusCode
          when 200
            id = _.pluck body.entries, "EntryId"
            msg.send id
          when 404
            msg.send "There was an error!"
          when 401
            msg.send "There was an authentication error!"
          else
            msg.send "I was unable to process your request"
    
