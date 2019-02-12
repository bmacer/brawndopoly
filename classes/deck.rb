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
    puts "\n\n\nvvvvvvvvvv"
    puts "Drawing Card...\n"
    puts card.show_card
    puts "^^^^^^^^^\n\n\n"
    card
  end

end
