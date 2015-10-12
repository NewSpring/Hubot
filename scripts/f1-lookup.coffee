# Description:
#   Looks for a fund ID against a search criteia in F1
#
# Configuration:
#   F1APIKEY - Fellowshipone API key
#
# Commands:
#   None
#
# Authors:
#   jbaxleyiii
#


request = require "request"
auth = "Basic #{process.env.F1APIKEY}"


FuzzySearch = require "fuzzysearch-js"
levenshteinFS = require "fuzzysearch-js/js/modules/LevenshteinFS"
indexOfFS = require "fuzzysearch-js/js/modules/IndexOfFS"
wordCountFS = require "fuzzysearch-js/js/modules/WordCountFS"

options =
  url: "https://newspring.fellowshiponeapi.com/giving/v1/funds.json"
  headers:
    "Authorization": auth

module.exports = (robot) ->
  robot.respond /lookup fund ?(.*)/i, (msg) ->
      name = msg.match[1]

      funds = []
      callback = (error, response, body) ->
        if not error and response.statusCode is 200
          info = JSON.parse(body)

          for fund in info.funds.fund
            funds.push(fund.name + ": " + fund["@id"])

          fuzzySearch = new FuzzySearch(funds,{"minimumScore": 300})
          fuzzySearch.addModule(levenshteinFS({"maxDistanceTolerance": 3, "factor": 3}))
          fuzzySearch.addModule(indexOfFS({"minTermLength": 3, "maxIterations": 500, "factor": 3}))
          fuzzySearch.addModule(wordCountFS({"maxWordTolerance": 3, "factor": 1}))

          console.log(name, funds);
          result = fuzzySearch.search(name)
          messageBack = []
          if result?.length
            messageBack.push "Here are the top results funds I found..."

            for fundScore in result
            	messageBack.push fundScore.value

          else
            messageBack.push "I'm sorry, I couldn't find any funds like that..."
          msg.reply(messageBack.join("\n"))
      request(options, callback)
