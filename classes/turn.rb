require_relative 'player'
require_relative 'space'
require_relative 'card'
require_relative 'deck'
require_relative '../scratch'

# TODO add the ability to mortgage
# TODO add the ability to sell houses
# TODO add 'in-the-red' requirement
# TODO add the ability to declare bankruptcy
# TODO add chance/community chest basic functionality
# TODO add comprehensive chance/community chest
# TODO add the ability to trade

class Turn

  @@total_turns = 0

  attr_accessor :player_list, :move, :roll_result, :messsage, :spaces, :double_count

  def initialize
    @double_count = 0
    @spaces = $spaces
    @deck = $deck

    @bankrupt_players = []

    @player_list = [
      Player.new({name: "brandon", human: true}),
      Player.new({name: "matt", human: false}),
      Player.new({name: "stephen", human: false}),
      Player.new({name: "alex", human: false})
    ]

    #@spaces.each do |i| # this gives player 1 brandon all the properties, to test monopoly/house-building functionality
    #  if i.is_property # && i.number != 3
    #    i.owner = @player_list[1]
    #    i.is_owned = true
    #  end
    #end
    @player_list[0].properties += [@spaces[1], @spaces[3]]
    @player_list[1].properties += [@spaces[37], @spaces[39]]
    @player_list[2].properties += [@spaces[11], @spaces[13], @spaces[14]]
    @player_list[3].properties += [@spaces[16], @spaces[18], @spaces[19]]
    [1,3,37,39,11,13,14,16,18,19].each {|i| @spaces[i].number_of_houses = 2}
    sleep(0.1)
    #[1, 3, 38, 39, 11, 12, 18, 19].each do |i|
    #  @spaces[i].is_owned = true
    #end
    

    until false
      player = @player_list[0]
      puts "\n\n\n\n\n\n"
      if player.human
        print "#{player.name} is currently on: #{@spaces[player.location].name}\nDecision time: 'r' to roll, 'b' to build, 's' for stats, 'q' to quit': "
        move = gets.chomp
        if move == 'q'
          exit
        elsif move == 'r'
          roll(player)
        elsif move == 'b'
          puts "building"
          if !check_for_monopoly(player)
            puts "no monopolies"
          else
            check_for_monopoly(player).each do |monopoly_index|
              monopolies_owned = @spaces.select do |space|
                space.property_family == monopoly_index
              end.each {|i| puts "#{i.number}: #{i.name} #{i.number_of_houses}"}
            end
          puts "Build House on which property? "
          choice = gets.chomp.to_i
          property = @spaces.select {|i| i.number == choice}[0]
          puts build_a_house_here(player, property)
          end
        elsif move == 's'
          display_stats
        end
      else
        roll(player)
        check_for_monopoly(player)
        if player.monopolies
          player.monopolies.reverse.each do |family_number|
            properties = @spaces.select {|i| i.property_family == family_number}
            properties.each do |j|
              build_a_house_here(player, j)
            end
          end
        end
      end
    end
  end

  def property_is_owned(property)
    @player_list.map {|player| player.properties.include?(property)}.any?
  end

  def which_player_owns(property)
    @player_list.select {|player| player.properties.include?(property)}[0]
  end

  def go_to_jail(player)
    puts "GO TO JAIL!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    player.location = 10
    player.in_jail = true
    player.turns_in_jail = 1
    @double_count = 0
    @player_list = @player_list.rotate
  end

  def draw_a_card
    @deck.pick_a_card
  end

  def check_for_monopoly(player) #TODO move monopoly/building methods to space class
    player_owned_sets = []
    families = @spaces.select {|i| i.is_property && !i.is_utility && !i.is_railroad}.map do |space|
      space.property_family
    end.uniq
    families.each do |i|
      total_in_family = @spaces.select {|space| space.property_family == i}.count
      #player_owns = @spaces.select {|space| space.owner == player && space.property_family == i}.count
      player_owns = player.properties.select {|space| space.property_family == i}.count
      #not sure about the above logic...
      if total_in_family == player_owns
        player_owned_sets << i
      end
    end
    puts "#{player.name} has #{player_owned_sets.length} monopolies"
    player.monopolies = player_owned_sets
  end

  def build_a_house_here(player, property) #TODO move monopoly/building methods to space class
    family_number_houses = @spaces.select {|space| space.property_family == property.property_family}.
    map{|space| space.number_of_houses}
    if which_player_owns(property) != player
      return "You don't own this property"
    elsif !player.monopolies.include?(property.property_family)
      return "You don't have a monopoly on this property"
    elsif property.number_of_houses + 1 > (family_number_houses.min + 1)
      return "You must build in a balanced way"
    elsif property.number_of_houses == 5
      return "You already have a hotel there"
    elsif player.bank < property.house_cost
      return "You don't have enough money for that"
    end
    player.bank -= property.house_cost
    property.number_of_houses += 1
    return true
  end

  def action_on_spot(player, space)
    if space.number == 30
      go_to_jail(player)
    elsif space.is_property
      puts "\n#{space.name}: $#{space.property_cost}"
      #if !space.is_owned
      if !property_is_owned(space)
        option_to_buy(player, space)
      elsif which_player_owns(space) != player
        if space.is_utility
          puts "is owned utility" #TODO deal with landing on utility
          land_on_utility(player, space)
        elsif space.is_railroad
          puts "is owned railroad" #TODO deal with landing on owned railroad
          land_on_railroad(player, space)
        else
          land_on_regular_property(player, space)
        end
      end
    elsif !space.is_property
      draw_a_card
    else
      print "YOU SHOULDN'T BE SEEING THIS."
    end
  end

  def land_on_utility(player, space)
  end

  def land_on_railroad(player, space)
  end

  def land_on_regular_property(player, space)
    if space.number_of_houses == 0
      money_transfer(player, space.rent, which_player_owns(space))
    else
      mapping = {"1" => space.with_one_house,
                 "2" => space.with_two_houses,
                 "3" => space.with_three_houses,
                 "4" => space.with_four_houses,
                 "5" => space.with_hotel}
      to_pay = mapping[space.number_of_houses.to_s]
      money_transfer(player, to_pay, which_player_owns(space))
    end
    puts "#{space.name} is owned by #{which_player_owns(space).name}!!"
    puts "#{space.number_of_houses ? (space.number_of_houses == 5 ? "HOTEL!" : "#{space.number_of_houses} house(s)") : ""}...Rent is #{to_pay || space.rent}"
  end

  def option_to_buy(player, space)
    if player.human
      puts "you have $#{player.bank}."
      print "purchase #{space.name} for $#{space.property_cost}? ('y' or 'n') "
      option = gets.chomp
      if option == 'y'
        money_transfer(player, space.property_cost)
        #space.is_owned = true
        #space.owner = player
        player.properties << space
        puts "#{space.name} purchased by #{player.name}"
      end
    else
      if player.bank > space.property_cost
        money_transfer(player, space.property_cost)
        #space.is_owned = true
        #space.owner = player
        player.properties << space
      end
    end
  end

  def money_transfer(player, amount, recipient=nil)
    player.bank -= amount
    if player.bank < 0
      player_in_the_red(player)
    end
    if recipient
      recipient.bank += amount
      if recipient.bank < 0
        player_in_the_red(recipient)
      end
    end
  end

  def player_in_the_red(player)
    until player.bank > 0 || @bankrupt_players.include?(player)
      puts "#{player.name} IS IN THE RED with $#{player.bank}"
      deal_with_debt(player)
    end
  end

  def deal_with_debt(player)
    puts "'s': sell houses, 'm' mortgage properties, 't' trade with others', 'b' declare bankruptcy, 'd' display player stats"
    choice = gets.chomp
    if choice == 'b'
      declare_bankruptcy(player)
    elsif choice == 's'
      can_sell = sell_houses_options(player)
      puts can_sell.class
      puts can_sell
      if can_sell[0] == true
        puts "Which property to sell houses on?"
        choice = gets.chomp
        puts sell_a_house_here(player, choice)
      end
    elsif choice == 'm'
      puts mortgage_properties(player)
    elsif choice == 'd'
      puts player.display
    end
  end

  def mortgage_properties(player)
    possible_properties_to_mortgage = player.properties.select {|i| !i.is_mortgaged && i.number_of_houses == 0}
    if possible_properties_to_mortgage.length == 0
      return "You have nothing to mortgage"
    end
    puts "#{player.name} has entered the mortgage properties zone"
    possible_properties_to_mortgage.each {|i| puts "[#{i.number}] #{i.name}"}
    puts "Which property to mortgage?"
    choice = gets.chomp
    mortgage_this_property(player, choice)
  end

  def mortgage_this_property(player, property)
    possible_properties_to_mortgage = player.properties.select {|i| !i.is_mortgaged && i.number_of_houses == 0}
    if !possible_properties_to_mortgage.include?(@spaces[property.to_i])
      return "You can't mortgage that."
    end
    property_to_mortgage = @spaces[property.to_i]
    property_to_mortgage.is_mortgaged = true
    player.bank += property_to_mortgage.mortgage_value
    puts player.bank
  end

  def sell_a_house_here(player, property)
    if !player.properties.each {|i| i.number}.include?(@spaces[property.to_i])
      return "You don't own that"
    end
    property_to_sell = @spaces[property.to_i]
    puts @spaces[1].property_family
    max_houses_in_family = @spaces.select {|i| i.property_family == property_to_sell.property_family}
      .inject(0) {|memo, n| n.number_of_houses > memo ? n.number_of_houses : memo}
    if property_to_sell.number_of_houses < max_houses_in_family
      return "You need to sell in a balanced way"
    end
    property_to_sell.number_of_houses -= 1
    player.bank += (property_to_sell.house_cost/2)
    puts player.bank
  end


  def sell_houses_options(player)
    if player.properties.map {|property| property.number_of_houses}.
      inject(0) {|sum, i| sum + i} == 0
      puts "You have no houses"
      return [false, "You don't own any houses"]
    end
    to_return = []
    player.properties.select do |property|
      property.number_of_houses > 0
    end.map do |property|
      puts "[#{property.number}] #{property.name}: #{property.number_of_houses} houses"
    end
    return [true, to_return.join("\n")]
  end

  def declare_bankruptcy(player)
    @player_list.delete(player)
    @bankrupt_players << player
    @spaces.each do |space|
      if which_player_owns(space) == player
        space.owner = nil
        space.is_owned = false
      end
    end
  end

  def roll_from_jail(player)

    puts "You're in jail.  This is roll number #{player.turns_in_jail} from jail."
    if player.turns_in_jail == 3
      puts "TOO MANY, you must pay"
      money_transfer(player, 100)
      player.in_jail = false
      player.turns_in_jail = 1
    end
    puts "Roll for doubles or pay $100?  'r' or 'p': "
    choice = "r"
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
    puts "#{player.name} | #{player.dice.display} | #{player.dice.doubles}"
    if player.dice.doubles
      player.in_jail == false
      player.turns_in_jail = 1
    else
  end
end

  def roll(player)
    @@total_turns += 1
    if @@total_turns > 200 || @player_list.length == 1
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

    player.location = (player.location + player.dice.total) % 40
    print "#{player.name} rolls: #{player.dice.display}\n#{player.name} is now on #{@spaces[player.location.to_i].name}"
    action_on_spot(player, @spaces[player.location.to_i])
    sleep(0.5)
  end



  def exit_game
    puts "exiting game"
    @spaces.each do |space|
      if space.is_property && property_is_owned(space)
        puts "#{space.name} owned by #{which_player_owns(space).name}"
      end
    end
    net_worths = []
    @player_list.each do |player|
      puts "~~~"
      puts player.name

      property_total = 0
      @spaces.find_all {|space| which_player_owns(space) == player}.each do |space|
        if !space.is_utility && !space.is_railroad
          puts "--> #{space.name} with #{space.number_of_houses == 5 ? 'a hotel' : space.number_of_houses.to_s + ' houses'}"
        elsif
          puts "--> #{space.name}"
        end
        property_total += space.property_cost
      end
      puts "Total Property Value: $#{property_total}"
      puts "Total Player Bank: $#{player.bank}"
      puts "Player Net Worth: $#{property_total + player.bank}"
      net_worths << "#{player.name}: #{property_total + player.bank}"
    end
    @spaces.find_all do |space|
      if space.is_property && !property_is_owned(space)
        puts "UNOWNED: #{space.name}"
      end
    end
    @player_list.each {|i| check_for_monopoly(i)}
    puts net_worths
    puts "Bankrupt Players\n"
    @bankrupt_players.each {|i| print "#{i.name}\n"}
    exit
  end

  def display_stats
    puts "\n\n\n\n\n\n\n\n\n\n\n\n---------------\nGAME STATISTICS\n---------------\n\n"
    @player_list.each do |player|
      puts player.name
      puts "----------"
      puts "Currently on: #{@spaces[player.location].name}"
      puts "Bank: $#{player.bank}"
      puts "Properties: "
      player.properties.each do |property|
        print property.name
        if property.number_of_houses == 5
          print " (with hotel)\n"
        elsif property.number_of_houses > 0
          print " (#{property.number_of_houses} houses)\n"
        else
          print "\n"
        end
      end
      puts "\n\n"
    end
  end

end
