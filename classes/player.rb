class Player

  attr_accessor :name, :human, :players_dice ,:location

  def initialize(options={})
    @location = 0
    @name = options[:name] || "Computer"
    @human = options[:human] ? true : false
  end

end
