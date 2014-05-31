module.exports =
  
  trustAlways: 
    onTurn: (cards, state) ->
      cards.randomize().first()
    
    onCardPlayed: (card, player, state) ->
      true
   
   trustAlwaysAndAlwaysGiveRightSuit:
    onTurn: (cards, state) ->
      suitable = cards.find (c) -> c.suit == state.currentSuit
      suitable || cards.randomize().first()
    
    onCardPlayed: (card, player, state) ->
      true
        
      
  trustNever:
    onTurn: (hand, state) ->
      hand.randomize().first()
    
    onCardPlayed: (card, player, state) ->
      false


  trustRandomly80:
    onTurn: (hand, state) ->
      hand.randomize().first()
    
    onCardPlayed: (card, player, state) ->
      return true if state.pileSize < 8
      Math.random() <= 0.8


  trustRandomly50:
    onTurn: (hand, state) ->
      hand.randomize().first()
    
    onCardPlayed: (card, player, state) ->
      return true if state.pileSize < 5
      Math.random() <= 0.8
