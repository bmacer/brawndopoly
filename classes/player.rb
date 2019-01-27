require_relative 'dice_set'

class Player

  attr_accessor :name, :human, :players_dice ,:location, :bank, \
   :in_jail, :turns_in_jail, :dice, :monopolies

  def initialize(options={})
    @location = 0
    @name = options[:name] || "Computer"
    @human = options[:human] ? true : false
    @bank = options[:bank] || 2000
    @dice = DiceSet.new
    @monopolies = []
  end

end
