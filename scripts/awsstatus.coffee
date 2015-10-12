# Description:
#   Outputs AWS status messages to defined room.
#
# Configuration:
#   HUBOT_OPS_ROOM - Room where message should be displayed
#
# Commands:
#   None
#
# Authors:
#   delianides
#   jeremykarn
#

fs = require('fs')
feedparser = require('ortoo-feedparser')

room = process.env.HUBOT_OPS_ROOM

last_check_time = 0
oldest_date_to_post = (new Date()).getTime() - (60 * 60 * 1000)
poll_interval = 60 * 1000

get_callback = (robot, user) ->
		parser_callback = (error, meta, articles) ->
				if error
						console.error(error)
				else
						now = (new Date()).getTime()
						for article in articles
								pubDate = Date.parse(article['pubdate'])
								if (pubDate - last_check_time) >= 0 and (pubDate - oldest_date_to_post) >= 0
										message = "@here - #{article.guid} - #{article.title} \n #{article.description}"
										robot.send user, message
						last_check_time = now
		return parser_callback

checkStatus = (robot) ->
		user = robot.brain.userForId 'Hubot'
		user.room = room
		out = feedparser.parseUrl("http://status.aws.amazon.com/rss/all.rss", get_callback(robot, user))

module.exports = (robot) ->
		setInterval(checkStatus, poll_interval, robot)
