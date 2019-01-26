class Player

  attr_accessor :name, :human, :players_dice ,:location, :bank

  def initialize(options={})
    @location = 0
    @name = options[:name] || "Computer"
    @human = options[:human] ? true : false
    @bank = options[:bank] || 2000
  end

end
