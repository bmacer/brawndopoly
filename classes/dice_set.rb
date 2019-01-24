require_relative 'dice'

class DiceSet < Dice

  def initialize
    @die_1, @die_2 = Dice.new, Dice.new
    display
  end

  def display
    "[#{@die_1.value}] [#{@die_2.value}]"
  end

  def roll
    @die_1.roll
    @die_2.roll
    display
  end

end
