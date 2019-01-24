require_relative 'player'

class Turn

  attr_accessor :player_list, :move, :roll_result, :messsage

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
    puts "#{@turn.name} is now on space #{@turn.location}"
    @message = ""
  end

  def initialize
    @message = ""
    @kill_switch = false
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
