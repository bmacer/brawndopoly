class Card

  attr_reader :action_type, :action_value

  def initialize
  end

end

go_to_go = Card.new({action_type: "move", action_value: 0})
