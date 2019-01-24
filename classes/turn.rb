require_relative 'player'
require_relative 'space'
require_relative '../scratch'


class Turn

  attr_accessor :player_list, :move, :roll_result, :messsage, :spaces, :double_count


  def go_to_jail
    puts "GO TO JAIL!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    @turn.location = 10
    @double_count = 0
    @player_list = @player_list.rotate
    puts "#{@turn.name} is now on #{$spaces[@turn.location.to_i].name} [[space #{@turn.location}]]\n\n"
  end

  def action_on_spot(player)
    if $spaces[player.location.to_i].number == 30
      sleep(0.2)
      go_to_jail
    end
  end

  def roll
    @die_1 = rand(6)+1
    @die_2 = rand(6)+1
    @roll_total = @die_1 + @die_2
    @roll_result = [@die_1, @die_2]

    if roll_result[0] != roll_result[1]
      @player_list = @player_list.rotate
      @double_count = 0
    else
      @double_count += 1
      if @double_count < 3
        @message = "doubles! "
      else
        @message = ""
        puts "#{@turn.name} rolls #{@message}[#{@roll_result.join('] [')}]"
        go_to_jail
        return
      end

    end
    puts "#{@turn.name} rolls #{@message}[#{@roll_result.join('] [')}]"
    @turn.location = (@turn.location + @roll_total) % 40
    puts "#{@turn.name} is now on #{$spaces[@turn.location.to_i].name} [[space #{@turn.location}]]\n\n"
    action_on_spot(@turn)
    @message = ""
  end

  def initialize
    @double_count = 0
    @message = ""
    @kill_switch = false
    @spaces = $spaces
    @player_list = [
      Player.new({name: "brandon", human: true}),
      Player.new({name: "matt", human: false}),
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
