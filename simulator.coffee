require "sugar"
fs = require "fs"

for lib in ["Deck"]
  fileName = lib.toLowerCase()
  GLOBAL[lib] = require("./#{fileName}")[lib]

for player in fs.readdirSync "players"
  klassName = player.split(".").first().camelize()
  GLOBAL[klassName] = require("./players/#{player}")[klassName]
    
class Game
  constructor: (args) ->
    { @deck, players } = args
    
    @cards     = @deck.cards()
    @stepCount = 0
    
    @pool = []
    @currentColor = 
    
    numCards = @cards.length / players.length
    
    @players = players.map (player) =>
      instance: new player()
      name: player.name
      cards: @cards.splice(0, numCards)
        
    @playersCount = Object.keys(@players).length
    
    
  step: ->
    
    player       = @players[@stepCount % @playersCount]
    otherPlayers = @players.findAll (p) -> p.name != player.name
    
    card = player.instance.playCard(player.cards)
    
    player.cards.remove(card)
    
    @currentColor = card.split(" ").first() if @pool.length == 0
    
    @pool.push card
    
    for otherPlayer in otherPlayers
      if (trust = otherPlayer.instance.cardPlayed(card, player.name)) == false
        
        if @pool.last().split(" ").first() == @currentColor
          console.log otherPlayer.name
          console.log "otherplayer get cards #{@pool.last().split(" ").first()} #{@currentColor}"
          otherPlayer.cards = otherPlayer.cards.add @pool
        else
          console.log otherPlayer.name
          console.log "player get cards #{@pool.last().split(" ").first()} #{@currentColor}"
          player.cards = player.cards.add @pool
        
        @pool = []
    
    @stepCount += 1
    
    

game = new Game(deck: new Deck(), players: [MoPlayer, BotPlayer])

console.log game.pool

console.log game.players.map (player) ->
  name: player.name
  cards: player.cards.length