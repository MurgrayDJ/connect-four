require 'matrix'

class Board
  attr_accessor :board

  def initialize(board = Matrix.build(6,7) {0})
    @board = board
  end

  def full?
    @board.any? {|spot| spot == 0} ? false : true
  end
end