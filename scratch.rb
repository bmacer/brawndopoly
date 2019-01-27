require_relative 'classes/space'
require_relative 'classes/card'
require_relative 'classes/deck'
require 'json'

$spaces = []
f = File.read("settings.json")
j = JSON.load(f)
j["spaces"].each do |k,v|
  $spaces << Space.new(
    {
      name: v["name"],
      number: v["number"],
      is_property: v["is_property"],
      is_railroad: v["is_railroad"],
      is_utility: v["is_utility"],
      action: v["action"],
      property_cost: v["property_cost"],
      rent: v["rent"],
      is_owned: false,
      house_cost: v["house_cost"],
      mortgage_value: v["mortgage_value"],
      with_one_house: v["with_one_house"],
      with_two_houses: v["with_two_houses"],
      with_three_houses: v["with_three_houses"],
      with_four_houses: v["with_four_houses"],
      with_hotel: v["with_hotel"],
      rent_two_rr: v["rent_two_rr"],
      rent_three_rr: v["rent_three_rr"],
      rent_four_rr: v["rent_four_rr"],
      multiplier_with_one_utility: v["multiplier_with_one_utility"],
      multiplier_with_two_utilities: v["multiplier_with_two_utilities"],
      number_of_houses: 0,
      property_family: v["property_family"]
    }
  )
end


















$cards = []
j["cards"]["chance"].each do |k,v|
  $cards << Card.new(
    {action_type: v["action_type"],
    action_value: v["action_value"]}
  )
end

$deck = Deck.new($cards)

puts $cards[0].action_type
