class Player

  attr_accessor :name, :is_human, :players_dice

  def initialize(options={})
    puts options
    @name = options[:name] || "Computer"
    @is_human = options[:is_human].nil? ? false : true
    @players_dice = DiceSet.new
    puts @players_dice.display
    puts @name
    puts @is_human
  end

  def display
    puts "#{@name} | #{@is_human}"
  end

  def roll
    @players_dice.roll
  end

end
