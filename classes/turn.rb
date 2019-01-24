class Turn

  attr_accessor :player_list, :move, :roll_result, :messsage

  def roll
    @roll_result = [rand(6)+1, rand(6)+1]

    if roll_result[0] != roll_result[1]
      @player_list = @player_list.rotate
    else
      @message = "doubles! "
    end
    puts "#{@turn[:name]} rolls #{@message}[#{@roll_result.join('] [')}]"
    @message = ""
  end

  def initialize
    @message = ""
    @kill_switch = false
    @player_list = [
      {name: "brandon",
      human: true},
      {name: "matt",
      human: true},
      {name: "computer",
      human: false}
    ]
    until false
      @turn = @player_list[0]
      if @turn[:human]
        print "#{@turn[:name]}: 'r' to roll, 'q' to quit': "
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
