class Space

  attr_reader :name, :number

  def initialize(options={})
    @name = options[:name]
    @number = options[:number]
  end

end
