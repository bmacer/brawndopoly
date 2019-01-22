require_relative 'dice'

class DiceSet < Dice

  def initialize
    @die_1, @die_2 = Dice.new, Dice.new
    puts @die_1
    puts @die_2
  end

end
