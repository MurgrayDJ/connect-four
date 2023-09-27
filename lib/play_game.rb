require_relative 'board.rb'
require_relative 'player.rb'

class PlayGame
  attr_reader :board
  attr_reader :player1
  attr_reader :player2
  DOT = "\u25CF"
  CIRCLE = "\u25CB"

  def initialize(board=Board.new)
    @board = board
  end

  def run_game
    puts "============ CONNECT FOUR ============"
    show_rules
    puts "Welcome Players! Please enter your names."
    create_players
  end

  def show_rules
    puts "\nHow to play: "
    puts " #{DOT} When it's your turn, choose the column you'd like your disk to"
    puts "   drop into."
    puts " #{CIRCLE} The first person to get four sequentially in a row, column, or"
    puts "   diagonal wins!"
    puts " #{DOT} Type 'exit' at any time to leave without saving."
    puts " #{CIRCLE} Type 'help' at any time to repeat this message.\n\n"
  end

  def create_players
    @player1 = Player.new(get_names(1), DOT)
    @player2 = Player.new(get_names(2), CIRCLE)
  end

  def get_names(player_num)
    name = nil
    while name.nil?
      name = confirm_name(player_num)
    end
    name
  end

  def confirm_name(player_num)
    print "Player #{player_num} name: "
    name = gets.chomp
    confirmation = "Confirm name #{name}? (Y/N): "
    response = get_valid_data(confirmation, nil, ["Y", "N"])
    if response == "N" then name = nil end
    name
  end

  def get_valid_data(prompt, response, valid_responses) 
    if response.nil?
      print prompt
      response = gets.chomp
    else
      response = response.upcase
      valid_responses.each do |valid_response|
        if response == valid_response
          return response
        elsif response == "exit"
          puts "Thank you for playing!"
          exit!
        elsif response == "help"
          show_rules
          break
        end
      end
      response = nil
    end
    response = get_valid_data(prompt, response, valid_responses)  
  end
end

 new_game = PlayGame.new
 new_game.run_game