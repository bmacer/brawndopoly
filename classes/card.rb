class Card

  attr_reader :action_type, :action_value, :show_card

  def initialize(options={})
    @action_type = options[:action_type]
    @action_value = options[:action_value]
  end

  def show_card
    "#{@action_type} ::: #{@action_value}"
  end

end
