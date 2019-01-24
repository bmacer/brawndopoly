require_relative 'player'

class Game

  attr_accessor :number_of_players, :players_turn_index, :r

  def initialize
    @player_1 = Player.new(options={name: "Brandon", is_human: false})
    @player_2 = Player.new(options={name: "Matt"})
    @player_1.display
    @player_2.display
    @players = [@player1, @player2]
    @number_of_players = 2
    @players_turn_index = 0
    # @active_player = @players[@players_turn_index]
    # puts @active_player
    while true
      if @players_turn_index == 0
        print "'r' to roll: "
        @r = players_choice
        if @r == 'r'
          @player_1.roll
          puts @player_1.players_dice.display
        end
        # puts @active_player.players_dice.die_1
      end
    end

  end

  def players_choice
    gets.chomp
  end

end
