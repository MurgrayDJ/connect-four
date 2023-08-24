require 'matrix'

class Board
  attr_accessor :board

  def initialize(board = Matrix.build(6,7) {0})
    @board = board
  end

end