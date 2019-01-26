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
        option_to_buy(player, space)
      end
    elsif !space.is_property
      draw_a_card
      puts "~~~~~~"
    else
      print ' is a property'
    end
  end

  def option_to_buy(player, space)
    if player.human
      puts "you have $#{player.bank}."
      print "purchase #{space.name} for $#{space.property_cost}? ('y' or 'n') "
      option = gets.chomp
      if option == 'y'
        money_transfer(player, space.property_cost)
        space.is_owned = true
        space.owner = player
        puts "#{space.name} purchased by #{player.name}"
      end
    else
      if player.bank > space.property_cost
        money_transfer(player, space.property_cost)
        space.is_owned = true
        space.owner = player
      end
    end
  end

  def money_transfer(from, amount, recipient=nil)
    from.bank -= amount
    if from.bank < 0
      player_in_the_red
    end
    if recipient
      recipient += amount
    end
  end

  def player_in_the_red
    puts "YOU ARE IN THE RED!!!!"
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

    @player_list.each do |player|
      puts "~~~"
      puts player.name
      puts "$#{player.bank}"
      $spaces.find_all {|space| space.owner == player}.each {|space| puts space.name}
    end
    $spaces.find_all do |space|
      if space.is_property && !space.is_owned
        puts "UNOWNED: #{space.name}"
      end
    end

    exit
  end

end
