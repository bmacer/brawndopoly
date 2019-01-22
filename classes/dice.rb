class Dice

  attr_reader :value

  def initialize
    @value = get_random_number
  end

  def get_random_number
    rand(6) + 1
  end

  private

  def roll
    @value = get_random_number
  end

end
