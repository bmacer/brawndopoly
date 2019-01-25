require_relative 'card'

class Deck

  include Enumerable

  attr_accessor :deck

  def each
    @deck.each {|item| yield(item)}
  end

  def initialize(array)
    @deck = array
  end

  def pick_a_card
    card = @deck.shift
    @deck << card
    puts card.show_card
    card
  end

end
