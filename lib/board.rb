require 'matrix'

class Board
  attr_accessor :board

  def initialize(board = Matrix.build(6,7) {0})
    @board = board
  end

  def full?
    return false if @board.all? {|spot| spot == 0}
    return true if @board.all? {|spot| spot == 1}
  end
end