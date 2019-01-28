require_relative 'dice_set'


class Player

  attr_accessor :name, :human, :players_dice ,:location, :bank, \
   :in_jail, :turns_in_jail, :dice, :monopolies, :properties

  def initialize(options={})
    @location = 0 #TODO: turn location into the space object, reference space.number when needed
    @name = options[:name] || "Computer"
    @human = options[:human] ? true : false
    @bank = options[:bank] || 2000
    @dice = DiceSet.new
    @monopolies = []
    @properties = []
  end

  def display
"""~~~~\nName: #{@name}
Location: #{@location}
Human: #{@human ? "Yes" : "No"}
Bank: #{@bank}
Dice: #{@dice.display}
Monopolies: #{@monopolies}
Properties:\n#{@properties.map {|i| "#{i.name}: #{i.number_of_houses}"}.join("\n")}\n~~~~
"""
  end

end
