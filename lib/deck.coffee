class Card
  constructor: (@suit, @value) ->
    @name = "#{@suit}#{@value}"
    

module.exports = class Deck
  defaults:
    suits: do -> "♠ ♥ ♦ ♣".split(" ")
    values: do -> "2 3 4 5 6 7 8 9 10 J Q K A".split(" ")
  
  constructor: (options = {}) ->
    @options = Object.merge @defaults, options, true
    @_cards  = []
    
    @generateCards()
  
  generateCards: ->
    for suit in @options.suits
      for value in @options.values
        @_cards.push new Card(suit, value)
    
    @shuffleCards()
    
  shuffleCards: ->
    @_cards = @_cards.randomize()
  
  cards: ->
    @_cards.slice()
