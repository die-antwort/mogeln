module.exports =
  
  trustAlways: 
    onTurn: (cards) ->
      cards.randomize().first()
    
    onCardPlayed: (card, player) ->
      true
      
      
  trustNever:
    onTurn: (hand) ->
      hand.randomize().first()
    
    onCardPlayed: (card, player) ->
      false


  trustRandomly:
    onTurn: (hand) ->
      hand.randomize().first()
    
    onCardPlayed: (card, player) ->
      Number.random(0, 10) < 8


  trustRandomly2:
    onTurn: (hand) ->
      hand.randomize().first()
    
    onCardPlayed: (card, player) ->
      Number.random(0, 10) < 5

