require 'matrix'

class Board
  attr_accessor :board
  NUM_ROWS = 6
  NUM_COLUMNS = 7
  DOT = "\u25CF"
  CIRCLE = "\u25CB"

  def initialize(board = Matrix.build(NUM_ROWS, NUM_COLUMNS) {" "})
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
      row.each {|spot| print "| #{spot} "}
      print "| \n"
    end
  end

  def full?
    @board.any? {|spot| spot == " "} ? false : true
  end

  def insert(game_symbol, column_num)
    (NUM_ROWS-1).downto(0) do |row_num|
      if @board[row_num, column_num] == " "
        @board[row_num, column_num] = game_symbol
        return [game_symbol, row_num, column_num]
      end
    end
    return nil
  end 

  def win?(game_symbol, row_num, column_num)
    return true if row_win?(game_symbol, row_num)
    false
  end

  def row_win?(game_symbol, row_num)
    counter = 0
    row = @board.row(row_num)
    row.each do |slot|
      if counter == 4
        return true
      elsif slot == game_symbol
        counter += 1
      else
        counter = 0
      end
    end
    false
  end
end

# testBoard = Board.new
# testBoard.print_board