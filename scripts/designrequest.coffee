# Description:
#   DesignRequest is the most important thing in your life
#
# Commands:
#   hubot hears DR ####, Returns Entry #### From Wufoo

##Include Underscore to parse response
_ = require 'underscore'
WUFOO_FORM_ID = 'z1g8lqa419afh2r'

getFields = (robot, api, callback) ->
    robot.http("https://#{api}:newspring@newspring.wufoo.com/api/v3/forms/#{WUFOO_FORM_ID}/fields.json")
    .headers(Accept: 'application/json')
    .get() (err, res, body) ->
      callback(err, res, body)

module.exports = (robot) ->
  robot.hear /(DR|dr)(( |)(\d+))?/i, (msg) ->
    entry_id = msg.match[2]
    api = process.env.WUFOO_API_KEY
    robot.http("https://#{api}:newspring@newspring.wufoo.com/api/v3/forms/#{WUFOO_FORM_ID}/entries.json?Filter1=EntryId+Is_equal_to+#{entry_id}")
      .headers(Accept: 'application/json')
      .get() (err, res, data) ->
        switch res.statusCode
          when 200
            getFields robot, api, (err, res, body) ->
              fields = _.toArray(_.pluck(_.flatten(JSON.parse(body)), "Title"))
              form = _.toArray(_.first(_.flatten(JSON.parse(data))))
              buildEntry = (entry) ->
                if !_.isEmpty(entry)
                  entry = entry.replace(/<(?:.|\n)*?>/gm, '') #Strips HTML since Hipchat doesn't support it yet.
                  "[#{fields[index]}]: #{entry}"
              msg.send (buildEntry entry for entry, index in form when entry isnt '').join('\n')
          when 404
            msg.send "There was an error with Wufoo: Entry Not Found!"
          when 401
            msg.send "There was an authentication error!"
          else
            msg.send "I was unable to process your request"
