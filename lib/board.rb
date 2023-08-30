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

    print "     | 0 | 1 | 2 | 3 | 4 | 5 | 6 |\n"
    print bottom_line
  end

  def print_rows
    @board.row_vectors.each do |row|
      print "     "
      row.each {|slot| print "| #{slot} "}
      print "| \n"
    end
  end

  def full?
    @board.any? {|slot| slot == " "} ? false : true
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
    return true if column_win?(game_symbol, column_num)
    return true if diagonal_win?(game_symbol, row_num, column_num)
    false
  end

  def row_win?(game_symbol, row_num)
    row = @board.row(row_num)
    four_discs?(row, game_symbol)
  end

  def column_win?(game_symbol, column_num)
    column = @board.column(column_num)
    four_discs?(column, game_symbol)
  end

  def diagonal_win?(game_symbol, row_num, column_num)
    down_diagonals = Hash[
      [2,0] => [[2,0], [3,1], [4,2], [5,3]],
      [1,0] => [[1,0], [2,1], [3,2], [4,3], [5,4]],
      [0,0] => [[0,0], [1,1], [2,2], [3,3], [4,4], [5,5]],
      [0,1] => [[0,1], [1,2], [2,3], [3,4], [4,5], [5,6]],
      [0,2] => [[0,2], [1,3], [2,4], [3,5], [4,6]],
      [0,3] => [[0,3], [1,4], [2,5], [3,6]]
    ]

    down_diagonals.each do |first_xy, diagonal|
      if diagonal.include?([row_num, column_num])
        four_discs?(diagonal, game_symbol)
      end
    end
  end

  def four_discs?(xy_list, game_symbol)
    counter = 0
    xy_list.each do |slot|
      if slot == game_symbol
        counter += 1
        if counter == 4
          return true
        end
      else
        counter = 0
      end
    end
    false
  end
end

# testBoard = Board.new
# testBoard.print_board