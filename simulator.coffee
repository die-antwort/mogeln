require "sugar"

Player     = require "./lib/player"
Deck       = require "./lib/deck"
Strategies = require "./lib/strategies"
Game       = require "./lib/game"

log = (args...) ->
  console.log.apply null, args

players = [
  new Player("Truster", Strategies.trustAlways)
  new Player("HonestTruster", Strategies.trustAlwaysAndAlwaysGiveRightSuit)
  new Player("RandomTruster50%", Strategies.trustRandomly50)
  new Player("RandomTruster80%", Strategies.trustRandomly80)
]

simulateGame = ->
  game = new Game(deck: new Deck(), players: players.randomize())
  game.step() until game.winner()
  # log "\nFINISHED!!!"
  # log "Winner: #{game.winner().name}"
  # game.logState()
  game.winner()


winners = (simulateGame() for i in [1..100])
log "\n\nSimulation ended after #{winners.length} games, winners:"
players.each (p) ->
  wins = winners.count(p) / winners.length * 100.0
  log "  #{wins.format(1).padLeft(5)}% #{p.name}"
  
log "\n"