module.exports = class Player
  constructor: (@name, strategies) ->
    {@onTurn, @onCardPlayed} = strategies

  setHand: (@hand) ->
    
  pickUp: (cards) ->
    @hand.add cards
    
  removeCard: (card) ->
    @hand.remove card