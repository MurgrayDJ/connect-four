require 'matrix'

class Board
  attr_accessor :board

  def initialize(board = Matrix.build(6,7) {0})
    @board = board
  end

  def print_board
    print " " + ("_" * 27)
    puts
    @board.row_vectors.each do |row|
      row.each do |spot|
        print "| #{spot} "
      end
      print "|"
      puts
    end
    print (" \u0305" * 27)
    puts
  end

  def full?
    @board.any? {|spot| spot == 0} ? false : true
  end
end

testBoard = Board.new
testBoard.print_board