require_relative 'classes/space'
require_relative 'classes/card'
require_relative 'classes/deck'
require 'json'

=begin
$spaces = []
[
{name: 'Go', number: 0, is_property: false},
{name: 'Mediterranean Avenue', number: 1, is_property: true},
{name: 'Community Chest', number: 2, is_property: false},
{name: 'Baltic Avenue', number: 3, is_property: true},
{name: 'Income Tax', number: 4, is_property: false},
{name: 'Reading Railroad', number: 5, is_property: true},
{name: 'Oriental Avenue', number: 6, is_property: true},
{name: 'Chance', number: 7, is_property: false},
{name: 'Vermont Avenue', number: 8, is_property: true},
{name: 'Connecticut Avenue', number: 9, is_property: true},
{name: 'Jail', number: 10, is_property: false},
{name: 'St. Charles Place', number: 11, is_property: true},
{name: 'Electric Company', number: 12, is_property: true},
{name: 'States Avenue', number: 13, is_property: true},
{name: 'Virginia Avenue', number: 14, is_property: true},
{name: 'Pennsylvania Railroad', number: 15, is_property: true},
{name: 'St. James Place', number: 16, is_property: true},
{name: 'Community Chest', number: 17, is_property: false},
{name: 'Tennessee Avenue', number: 18, is_property: true},
{name: 'New York Avenue', number: 19, is_property: true},
{name: 'Free Parking', number: 20, is_property: false},
{name: 'Kentucky Avenue', number: 21, is_property: true},
{name: 'Chance', number: 22, is_property: false},
{name: 'Indiana Avenue', number: 23, is_property: true},
{name: 'Illinois Avenue', number: 24, is_property: true},
{name: 'B & O Railroad', number: 25, is_property: true},
{name: 'Atlantic Avenue', number: 26, is_property: true},
{name: 'Ventnor Avenue', number: 27, is_property: true},
{name: 'Water Works', number: 28, is_property: true},
{name: 'Marvin Gardens', number: 29, is_property: true},
{name: 'Go To Jail', number: 30, is_property: false, action: 'go_to_jail'},
{name: 'Pacific Avenue', number: 31, is_property: true},
{name: 'North Carolina Avenue', number: 32, is_property: true},
{name: 'Community Chest', number: 33, is_property: false},
{name: 'Pennsylvania Avenue', number: 34, is_property: true},
{name: 'Short Line Railroad', number: 35, is_property: true},
{name: 'Chance', number: 36, is_property: false},
{name: 'Park Place', number: 37, is_property: true},
{name: 'Luxury Tax', number: 38, is_property: false},
{name: 'Boardwalk', number: 39, is_property: true},
].each do |i|
  puts i
  $spaces << Space.new({name: i[:name], number: i[:number], is_property: i[:is_property]})
end

cards = []
[
  {action_type: "move", action_value: 0},
  {action_type: "get", action_value: -50},
  {action_type: "get", action_value: 50},
  {action_type: "move", action_value: 30}
].each do |i|
  cards << Card.new(
    {action_type: i[:action_type],
    action_value: i[:action_value]}
  )
end

$deck = Deck.new(cards)


puts $d.deck[0][:action_type]
draw = $d.pick_a_card
puts draw[:action_type]
$d.each {|i| puts i[:action_value]}
=end

$spaces = []
f = File.read("settings.json")
j = JSON.load(f)
j["spaces"].each do |k,v|
  $spaces << Space.new(
    {name: v["name"], number: v["number"], is_property: v["is_property"]}
  )
  #$spaces << v["name"]
end
# puts $spaces[0].name

$cards = []
j["cards"]["chance"].each do |k,v|
  $cards << Card.new(
    {action_type: v["action_type"],
    action_value: v["action_value"]}
  )
end

$deck = Deck.new($cards)

puts $cards[0].action_type
