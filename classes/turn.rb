require_relative 'player'
require_relative 'space'

class Turn

  attr_accessor :player_list, :move, :roll_result, :messsage, :spaces

  def roll
    @die_1 = rand(6)+1
    @die_2 = rand(6)+1
    @roll_total = @die_1 + @die_2
    @roll_result = [@die_1, @die_2]

    if roll_result[0] != roll_result[1]
      @player_list = @player_list.rotate
    else
      @message = "doubles! "
    end
    puts "#{@turn.name} rolls #{@message}[#{@roll_result.join('] [')}]"
    @turn.location = (@turn.location + @roll_total) % 40
    puts "#{@turn.name} is now on #{@spaces[@turn.location.to_i].name} [[space #{@turn.location}]]\n\n"
    @message = ""
  end

  def initialize
    @message = ""
    @kill_switch = false
    @spaces = [
      Space.new(options = {name: 'Go', number: 0}),
      Space.new(options = {name: 'Mediterranean Avenue', number: 1}),
      Space.new(options = {name: 'Community Chest', number: 2}),
      Space.new(options = {name: 'Baltic Avenue', number: 3}),
      Space.new(options = {name: 'Income Tax', number: 4}),
      Space.new(options = {name: 'Reading Railroad', number: 5}),
      Space.new(options = {name: 'Oriental Avenue', number: 6}),
      Space.new(options = {name: 'Chance', number: 7}),
      Space.new(options = {name: 'Vermont Avenue', number: 8}),
      Space.new(options = {name: 'Connecticut Avenue', number: 9}),
      Space.new(options = {name: 'Jail', number: 10}),
      Space.new(options = {name: 'St. Charles Place', number: 11}),
      Space.new(options = {name: 'Electric Company', number: 12}),
      Space.new(options = {name: 'States Avenue', number: 13}),
      Space.new(options = {name: 'Virginia Avenue', number: 14}),
      Space.new(options = {name: 'Pennsylvania Railroad', number: 15}),
      Space.new(options = {name: 'St. James Place', number: 16}),
      Space.new(options = {name: 'Community Chest', number: 17}),
      Space.new(options = {name: 'Tennessee Avenue', number: 18}),
      Space.new(options = {name: 'New York Avenue', number: 19}),
      Space.new(options = {name: 'Free Parking', number: 20}),
      Space.new(options = {name: 'Kentucky Avenue', number: 21}),
      Space.new(options = {name: 'Chance', number: 22}),
      Space.new(options = {name: 'Indiana Avenue', number: 23}),
      Space.new(options = {name: 'Illinois Avenue', number: 24}),
      Space.new(options = {name: 'B & O Railroad', number: 25}),
      Space.new(options = {name: 'Atlantic Avenue', number: 26}),
      Space.new(options = {name: 'Ventnor Avenue', number: 27}),
      Space.new(options = {name: 'Water Works', number: 28}),
      Space.new(options = {name: 'Marvin Gardens', number: 29}),
      Space.new(options = {name: 'Go To Jail', number: 30}),
      Space.new(options = {name: 'Pacific Avenue', number: 31}),
      Space.new(options = {name: 'North Carolina Avenue', number: 32}),
      Space.new(options = {name: 'Community Chest', number: 33}),
      Space.new(options = {name: 'Pennsylvania Avenue', number: 34}),
      Space.new(options = {name: 'Short Line Railroad', number: 35}),
      Space.new(options = {name: 'Chance', number: 36}),
      Space.new(options = {name: 'Park Place', number: 37}),
      Space.new(options = {name: 'Luxury Tax', number: 38}),
      Space.new(options = {name: 'Boardwalk', number: 39}),
    ]
    @player_list = [
      Player.new({name: "brandon", human: true}),
      Player.new({name: "matt", human: true}),
      Player.new({name: "computer_1", human: false}),
      Player.new({name: "computer_2", human: false})
    ]
    until false
      @turn = @player_list[0]
      if @turn.human
        print "#{@turn.name}: 'r' to roll, 'q' to quit': "
        @move = gets.chomp
        if @move == 'q'
          exit
        elsif @move == 'r'
          roll
        end
      else
        roll
      end
    end
  end

end
