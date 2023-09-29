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
    print_title
    print_rules
    puts "Welcome Players! Please enter your names."
    create_players
  end

  # def play_game
  #   round_count = 0
  #   round_data = ''
  #   while !@board.full?
  #     round_count++;
  #     if round_count.odd?
  #       round_data = play_round(player1)
  #       if @board.win?(*round_data)
  #         after_game("#{player1.name} wins! :D")
  #       end
  #     else
  #       round_data = play_round(player2)
  #       if @board.win?(*round_data)
  #         after_game("#{player2.name} wins! :D")
  #       end
  #     end
  #   end
  #   after_game("Looks like a tie! :)")
  # end

  def play_round(curr_player)
    @board.print_board
    puts "#{curr_player.game_symbol} #{curr_player.name} it's your turn!"
    prompt = "Please pick a column (0-6): "
    choice = get_valid_data(prompt, nil, ('0'..'6').to_a).to_i
    round_data = @board.insert(curr_player.game_symbol, choice)
    while insert_data.nil? do
      print "Column full! "
      prompt = "Please pick a valid column (0-6): "
      choice = get_valid_data(prompt, nil, ('0'..'6').to_a).to_i
      round_data = @board.insert(curr_player.game_symbol, choice)
    end
    puts
    @board.print_board
    round_data
  end

  def print_title
    title = ''
    title = add_title_circles(title)
    title << " CONNECT FOUR "
    title = add_title_circles(title)
    puts title
  end

  def add_title_circles (title)
    (0..8).each do |num|
      if num.even?
        title << "#{CIRCLE} "
      else
        title << "#{DOT} "
      end
    end
    title
  end

  def print_rules
    puts "\nHow to play: "
    puts " #{DOT} When it's your turn, choose the column you'd like your disk to"
    puts "   drop into."
    puts " #{CIRCLE} The first person to get four sequentially in a row, column, or"
    puts "   diagonal wins!"
    puts " #{DOT} Type 'exit' to leave at any time."
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
          print_rules
          break
        end
      end
      response = nil
    end
    response = get_valid_data(prompt, response, valid_responses)  
  end
end

#  new_game = PlayGame.new
#  new_game.run_game