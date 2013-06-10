# Description:
#   WebRequest is the most important thing in your life
#
# Commands:
#   hubot hears WR 232, Returns Entry #232 From Wufoo 

module.exports = (robot) ->
  robot.respond /(WR|wr)( (\d+))?/i, (msg) ->
    entry_id = msg.match[2]
    user = process.env.WUFOO_API_KEY
    pass = "newspring" #not used by the wufoo API
    auth = 'Basic ' + new Buffer(user + ':' + pass).toString('base64')
    msg.http("https://newspring.wufoo.com/api/v3/forms/web-request/entries.json?Filter1=EntryId+Is_equal_to+#{entry_id}")
      .headers(Authorization: auth, Accept: 'application/json')
      .get() (err, res, body) ->
        switch res.statusCode
          when 200
            msg.send body
          when 404
            msg.send "There was an error!"
          when 401
            msg.send "There was an authentication error!"
          else
            msg.send "I was unable to process your request"
    
