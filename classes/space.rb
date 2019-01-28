class Space

  attr_reader :name, :number, :is_property, :is_utility, :is_railroad, :action, :property_cost, \
  :rent, :house_cost, :mortgage_value, :with_one_house, :with_two_houses, \
  :with_three_houses, :with_four_houses, :with_hotel, :rent_two_rr, \
  :rent_three_rr, :rent_four_rr, :multiplier_with_one_utility, :multiplier_with_two_utilities, :property_family
  attr_accessor  :number_of_houses, :is_mortgaged #,:is_owned, :owner

  def initialize(options={})
    @name = options[:name]
    @number = options[:number]
    @is_property = options[:is_property]
    @is_railroad = options[:is_railroad]
    @is_utility = options[:is_utility]
    @action = options[:action]
    @property_cost = options[:property_cost]
    @rent = options[:rent]
    @is_owned = false
    @house_cost = options[:house_cost]
    @mortgage_value = options[:mortgage_value]
    @with_one_house = options[:with_one_house]
    @with_two_houses = options[:with_two_houses]
    @with_three_houses = options[:with_three_houses]
    @with_four_houses = options[:with_four_houses]
    @with_hotel = options[:with_hotel]
    @rent_two_rr = options[:rent_two_rr]
    @rent_three_rr = options[:rent_three_rr]
    @rent_four_rr = options[:rent_four_rr]
    @multiplier_with_one_utility = options[:multiplier_with_one_utility]
    @multiplier_with_two_utilities = options[:multiplier_with_two_utilities]
    @property_family = options[:property_family]
    @number_of_houses = 0
    @is_mortgaged = false
  end

end
