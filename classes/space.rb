class Space

  attr_reader :name, :number, :is_property, :action, :property_cost,
  :rent
  attr_accessor :is_owned, :owner

  def initialize(options={})
    @name = options[:name]
    @number = options[:number]
    @is_property = options[:is_property]
    @action = options[:action]
    @property_cost = options[:property_cost]
    @rent = options[:rent]
    @is_owned = false
  end

end
