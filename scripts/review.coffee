

module.exports = (robot) ->

  team = [
    '@ben'
    '@drew'
    '@david'
    '@brian'
    '@ed'
    '@sam'
    '@john'
  ]

  directors = [
    '@james'
    '@jon'
  ]

  shuffle = (array) ->
    currentIndex = array.length
    temporaryValue = undefined
    randomIndex = undefined
    # While there remain elements to shuffle...
    while 0 != currentIndex
      # Pick a remaining element...
      randomIndex = Math.floor(Math.random() * currentIndex)
      currentIndex -= 1
      # And swap it with the current element.
      temporaryValue = array[currentIndex]
      array[currentIndex] = array[randomIndex]
      array[randomIndex] = temporaryValue
    array
  
  
  robot.respond /it\'s review time/i, (msg) ->
    
    msg.reply(
      "
      @here, for review today: #{shuffle(team).join(' ')}
      and then #{shuffle(directors).join(' and ')}
      if they have anything they want to share
      "
    )
