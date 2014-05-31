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
  
  logState: (s) ->
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

    state = @state()
    card = @currentPlayer.onTurn.call(null, @currentPlayer.hand, state)
    @currentSuit = card.suit if @pile.length == 0
    # @logState(state)
    # log "  #{@currentPlayer.name} plays #{card.name}"
    @currentPlayer.removeCard(card)
    @pile.push card

    
    for otherPlayer in otherPlayers
        # log "    #{otherPlayer.name} trusts"
      if (trust = otherPlayer.onCardPlayed.call(null, card, @currentPlayer.name, state))
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