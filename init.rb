require_relative "classes/dice"
require_relative "classes/dice_set"

d = Dice.new
d2 = Dice.new

puts d.value
d.roll
puts d.value
puts d2.value

ds = DiceSet.new

puts ds
