require_relative 'player'
require_relative 'space'
require_relative 'card'
require_relative 'deck'
require_relative '../scratch'

class Turn

  @@total_turns = 0

  attr_accessor :player_list, :move, :roll_result, :messsage, :spaces, :double_count

  def go_to_jail
    puts "GO TO JAIL!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    @turn.location = 10
    @double_count = 0
    @player_list = @player_list.rotate
    puts "#{@turn.name} is NOW on #{$spaces[@turn.location.to_i].name} [[space #{@turn.location}]] "
  end

  def draw_a_card
    print ' not a property'
    $deck.pick_a_card
  end

  def action_on_spot(player, space)
    if space.number == 30
      go_to_jail
    elsif space.is_property
      puts "\n#{space.name}: $#{space.property_cost}"
      if !space.is_owned
        space.is_owned = true
        space.owner = player
      end
    elsif !space.is_property
      draw_a_card
      puts "~~~~~~"
    else
      print ' is a property'
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
        print "#{@turn.name} rolls #{@message}[#{@roll_result.join('] [')}]"
        go_to_jail
        return
      end

    end
    @@total_turns += 1
    if @@total_turns > 50
      exit_game
    end
    print "\n#{@turn.name} rolls #{@message}[#{@roll_result.join('] [')}]"
    @turn.location = (@turn.location + @roll_total) % 40
    print "\n\n#{@turn.name} is now on #{$spaces[@turn.location.to_i].name} [[space #{@turn.location}]] "
    action_on_spot(@turn, $spaces[@turn.location.to_i])
    @message = ""
  end

  def initialize
    @double_count = 0
    @message = ""
    @kill_switch = false
    @spaces = $spaces
    @player_list = [
      Player.new({name: "brandon", human: false}),
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

  def exit_game
    puts "exiting game"
    $spaces.each do |space|
      if space.is_property && space.is_owned
        puts "#{space.name} owned by #{space.owner.name}"
      end
    end
    
    exit
  end

end
