# Description:
#   WebRequest is the most important thing in your life
#
# Commands:
#   hubot hears WR ####, Returns Entry #### From Wufoo 

##Include Underscore to parse response
_ = require 'underscore'

getFields = (robot, api, callback) ->
    robot.http("https://#{api}:newspring@newspring.wufoo.com/api/v3/forms/web-request/fields.json")
    .headers(Accept: 'application/json')
    .get() (err, res, body) ->
      callback(err, res, body)
     
module.exports = (robot) ->
  robot.hear /(WR|wr)(( |)(\d+))?/i, (msg) ->
    entry_id = msg.match[2]
    api = process.env.WUFOO_API_KEY
    robot.http("https://#{api}:newspring@newspring.wufoo.com/api/v3/forms/web-request/entries.json?Filter1=EntryId+Is_equal_to+#{entry_id}")
      .headers(Accept: 'application/json')
      .get() (err, res, data) ->
        switch res.statusCode
          when 200
            getFields robot, api, (err, res, body) ->
              fields = _.pluck(_.flatten(JSON.parse(body)), "Title")
              form = _.first(_.flatten(JSON.parse(data)))
              msg.send "WR##{form.EntryId} | #{form.Field159}"
              msg.send "#{form.Field166} - #{form.Field167}"
              msg.send "#{form.Field80}, #{form.Field12}, ex:#{form.Field103}"
              msg.send "------------------------------------------------------"
              fields = _.toArray(fields).slice(7)
              form = _.toArray(form).slice(7)
              i = 0
              _.map form, (data, key) ->
                  if !_.isEmpty(data)
                    data = data.replace(/<(?:.|\n)*?>/gm, '') #Strips HTML since Hipchat doesn't support it yet.
                    msg.send "#{fields[i]} #{data}"
                  i++
          when 404
            msg.send "There was an error!"
          when 401
            msg.send "There was an authentication error!"
          else
            msg.send "I was unable to process your request"
