

class PlayGame
  attr_reader :board
  attr_reader :player1
  attr_reader :player2

  def initialize(board)
    @board = Board.new
  end
end