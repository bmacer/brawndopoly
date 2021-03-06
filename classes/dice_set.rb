require_relative 'dice'

class DiceSet < Dice

  attr_reader :total, :doubles

  def initialize
    @die_1, @die_2 = Dice.new, Dice.new
    @total = @die_1.value + @die_2.value
    @doubles = @die_1.value == @die_2.value
    display
  end

  def display
    "[#{@die_1.value}] [#{@die_2.value}] #{@doubles ? "Doubles!" : ""}"
  end

  def roll
    @die_1.roll
    @die_2.roll
    @total = @die_1.value + @die_2.value
    @doubles = @die_1.value == @die_2.value
    display
  end

end
