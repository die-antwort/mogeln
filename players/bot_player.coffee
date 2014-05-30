class exports.BotPlayer
  
  constructor: ->
    
  
  playCard: (cards) ->
    cards.randomize().first()
    
  cardPlayed: (card, player) ->
    [false, false, false, false, false].randomize().first()