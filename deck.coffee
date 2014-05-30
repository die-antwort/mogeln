class exports.Deck
  
  defaults:
    colors: do -> "spade heart diamond club".split(" ")
    types: do -> "2 3 4 5 6 7 8 9 10 J Q K A".split(" ")
  
  constructor: (options = {}) ->
    @options = Object.merge @defaults, options, true
    @_cards  = []
    
    @generateCards()
  
  generateCards: ->
    for color in @options.colors
      for type in @options.types
        @_cards.push "#{color} #{type}"
    
    @shuffleCards()
    
  shuffleCards: ->
    @_cards = @_cards.randomize()
  
  cards: ->
    @_cards.slice()