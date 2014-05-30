require "sugar"
fs         = require "fs"
Player     = require "./player"
Deck       = require "./deck"
Strategies = require "./strategies"

log = (args...) ->
  console.log.apply null, args
  
class Game
  constructor: (args) ->
    { @deck, @players } = args
    
    @cards     = @deck.cards()
    
    @pile = []
    @currentSuit = null
    numCards = @cards.length / players.length
    
    player.setHand @cards.splice(0, numCards) for player in @players
  
  logState: ->
    s = @state()
    log "\n#{s.currentPlayer.name}’s turn, current suit: #{s.currentSuit}"
    log "Pile: #{s.pileSize}, " + s.handSizes.map((h) -> "#{h.name}: #{h.size}").join(", ")
    
    
  state: ->
    currentSuit: @currentSuit
    currentPlayer: @currentPlayer
    pileSize: @pile.length
    handSizes: @players.map (p) -> {name: p.name, size: p.hand.length}
  
  winner: ->
    @players.find (p) -> p.hand.length == 0
    
  step: ->
    @currentPlayer = @players[0]
    otherPlayers = @players[1..]

    card = @currentPlayer.onTurn.call(null, @currentPlayer.hand)
    @currentSuit = card.suit if @pile.length == 0
    # @logState()
    # log "  #{@currentPlayer.name} plays #{card.name}"
    @currentPlayer.removeCard(card)
    @pile.push card

    
    for otherPlayer in otherPlayers
      if (trust = otherPlayer.onCardPlayed.call(null, card, @currentPlayer.name))
        # log "    #{otherPlayer.name} trusts"
      else
        # log "    #{otherPlayer.name} does not trust"
        
        if @pile.last().suit == @currentSuit
          # log "      FAIL! #{otherPlayer.name} picks up pile"
          otherPlayer.pickUp @pile
          nextPlayer = otherPlayer
        else
          # log "      WIN! #{@currentPlayer.name} picks up pile"
          @currentPlayer.pickUp @pile
          nextPlayer = @currentPlayer
        @pile = []
        break
    
    @players.push @players.shift()
    @players.push @players.shift() while nextPlayer && @players[0] != nextPlayer
    

players = [
  # new Player("Truster2", Strategies.trustAlways)
  # new Player("Truster3", Strategies.trustAlways)
  # new Player("Truster1", Strategies.trustAlways)
#  new Player("Nontruster2", Strategies.trustNever)
  new Player("RandomTruster1", Strategies.trustRandomly)
  new Player("XXX4", Strategies.trustRandomly2)
  new Player("RandomTruster2", Strategies.trustRandomly)
  new Player("RandomTruster3", Strategies.trustRandomly)
]

simulateGame = ->
  game = new Game(deck: new Deck(), players: players)
  game.step() until game.winner()
  # log "\nFINISHED!!!"
  # log "Winner: #{game.winner().name}"
  # game.logState()
  game.winner()


winners = (simulateGame() for i in [1..1000])
log "\n\nSimulation ended"
players.each (p) ->
  log "#{p.name}: #{winners.count(p)} wins"