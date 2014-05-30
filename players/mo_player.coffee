class exports.MoPlayer
  
  constructor: ->
  
  playCard: (cards) ->
    cards.randomize().first()
    
  cardPlayed: (card, player) ->
    [true, true, true, true, true].randomize().first()