require_relative 'player'
require_relative 'space'
require_relative 'card'
require_relative 'deck'
require_relative '../scratch'

class Turn

  @@total_turns = 0

  attr_accessor :player_list, :move, :roll_result, :messsage, :spaces, :double_count

  def go_to_jail(player)
    puts "GO TO JAIL!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    @turn.location = 10
    player.in_jail = true
    player.turns_in_jail = 1
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
      go_to_jail(player)
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

  def money_transfer(player, amount, recipient=nil)
    player.bank -= amount
    if player.bank < 0
      player_in_the_red
    end
    if recipient
      recipient += amount
    end
  end

  def player_in_the_red
    puts "YOU ARE IN THE RED!!!!"
  end

  def roll_from_jail(player)

    puts "You're in jail.  This is roll number #{player.turns_in_jail} from jail."
    if player.turns_in_jail == 3
      puts "TOO MANY, you must pay"
      puts player.bank
      money_transfer(player, 100)
      puts player.bank
      player.in_jail = false
      player.turns_in_jail = 1
      sleep(1)
    end
    puts "Roll for doubles or pay $100?  'r' or 'p': "
     sleep(0.5)
    # choice = gets.chomp
    choice = 'r'
    if choice == 'r'
      print("rolling...")
      player.dice.roll
      if player.dice.doubles
        player.in_jail == false
        player.turns_in_jail = 1
      else
        player.turns_in_jail += 1
      end
    elsif choice == 'p'
      money_transfer(player, 100)
      player.in_jail == false
      player.turns_in_jail = 1
      print("paying...")
    else
      print("other...")
    end

    puts player.dice.display
    puts player.dice.doubles
    puts player.name
    if player.dice.doubles
      player.in_jail == false
      player.turns_in_jail = 1
    else
  end
end

  def roll(player)
    @@total_turns += 1
    if @@total_turns > 50
      exit_game
    end

    if player.in_jail
      roll_from_jail(player)
    end

    player.dice.roll
    if !player.dice.doubles
      @player_list = @player_list.rotate
      @double_count = 0
    else
      @double_count += 1
      if @double_count == 3
        @double_count = 0
        go_to_jail(player)
      end
    end



    #print "\n#{player.name} rolls #{@message}[#{@roll_result.join('] [')}]"
    print player.dice.display
    player.location = (player.location + player.dice.total) % 40
    print "\n\n#{player.name} is now on #{$spaces[player.location.to_i].name} [[space #{player.location}]] "
    action_on_spot(player, $spaces[player.location.to_i])
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
          roll(@turn)
        end
      else
        roll(@turn)
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
