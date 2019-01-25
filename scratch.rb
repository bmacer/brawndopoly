require_relative 'classes/space'
require_relative 'classes/card'
require_relative 'classes/deck'
require 'json'

$spaces = []
f = File.read("settings.json")
j = JSON.load(f)
j["spaces"].each do |k,v|
  $spaces << Space.new(
    {name: v["name"], number: v["number"], is_property: v["is_property"]}
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
