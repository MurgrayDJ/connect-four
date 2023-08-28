require 'matrix'

class Board
  attr_accessor :board

  def initialize(board = Matrix.build(6,7) {" "})
    @board = board
  end

  def print_board
    top_line = "      " + ("_" * 27) + "\n"
    bottom_line = "     " + (" \u0305" * 27) + "\n"
    
    print top_line 
    print_rows
    print bottom_line
  end

  def print_rows
    @board.row_vectors.each do |row|
      print "     "
      row.each do |spot|
        print "| #{spot} "
      end
      print "| \n"
    end
  end

  def full?
    @board.any? {|spot| spot == " "} ? false : true
  end
end

# testBoard = Board.new
# testBoard.print_board