class Space

  attr_reader :name, :number, :is_property, :action

  def initialize(options={})
    @name = options[:name]
    @number = options[:number]
    @is_property = options[:is_property]
    @action = options[:action]
  end

end
