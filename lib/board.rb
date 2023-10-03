require 'matrix'

class Board
  attr_accessor :board
  NUM_ROWS = 6
  NUM_COLUMNS = 7
  DOT = "\u25CF"
  CIRCLE = "\u25CB"
  CHECKMARK = "\u2713"
  DOWN_DIAGONALS = Hash[
    [2,0] => [[2,0], [3,1], [4,2], [5,3]],
    [1,0] => [[1,0], [2,1], [3,2], [4,3], [5,4]],
    [0,0] => [[0,0], [1,1], [2,2], [3,3], [4,4], [5,5]],
    [0,1] => [[0,1], [1,2], [2,3], [3,4], [4,5], [5,6]],
    [0,2] => [[0,2], [1,3], [2,4], [3,5], [4,6]],
    [0,3] => [[0,3], [1,4], [2,5], [3,6]]
  ]

  UP_DIAGONALS = Hash[
    [3,0] => [[3,0], [2,1], [1,2], [0,3]],
    [4,0] => [[4,0], [3,1], [2,2], [1,3], [0,4]],
    [5,0] => [[5,0], [4,1], [3,2], [2,3], [1,4], [0,5]],
    [5,1] => [[5,1], [4,2], [3,3], [2,4], [1,5], [0,6]],
    [5,2] => [[5,2], [4,3], [3,4], [2,5], [1,6]],
    [5,3] => [[5,3], [4,4], [3,5], [2,6]]
  ]

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
    @board.row_vectors.each_with_index do |row, row_num|
      print "    #{row_num}"
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
    return true if row_win?(game_symbol, row_num, column_num)
    return true if column_win?(game_symbol, row_num, column_num)
    return true if diagonal_win?(game_symbol, row_num, column_num)
    false
  end

  def row_win?(game_symbol, row_num, column_num)
    row = @board.row(row_num)
    result = four_discs?(row, game_symbol)
    if result
      add_row_col_checkmarks(row, row_num, nil)
      print_board
    end
    result
  end

  def column_win?(game_symbol, row_num, column_num)
    column = @board.column(column_num)
    result = four_discs?(column, game_symbol)
    if result
      add_row_col_checkmarks(column, nil, column_num)
      print_board
    end
    result
  end

  def add_row_col_checkmarks(disc_list, row_num, column_num)
    disc_list.each_with_index do |slot, index|
      disc_group = [disc_list[index], disc_list[index + 1], disc_list[index + 2], disc_list[index+ 3]]
      if disc_group.uniq.length == 1
        if row_num.nil?
          (index..index+3).each do |idx|
            @board[idx, column_num] = CHECKMARK
          end
        elsif column_num.nil?
          (index..index+3).each do |idx|
            @board[row_num, idx] = CHECKMARK
          end
        end
      end
    end
  end

  def diagonal_win?(game_symbol, row_num, column_num)
    return true if diagonal_check(DOWN_DIAGONALS, game_symbol, row_num, column_num)
    return true if diagonal_check(UP_DIAGONALS, game_symbol, row_num, column_num)
    false
  end

  def diagonal_check(diag_direction, game_symbol, row_num, column_num)
    result = false
    diag_direction.each do |first_xy, diagonal|
      xy_list = []
      diagonal.each{|xy| xy_list << xy.dup}
      if diagonal.include?([row_num, column_num])
        diagonal.map! {|slot| slot = @board[slot[0], slot[1]]}
        result = four_discs?(diagonal, game_symbol) 
        if result
          add_diag_checkmarks(xy_list, diagonal)
          print_board
        end
      end
    end
    result
  end

  def add_diag_checkmarks(xy_list, disc_list)
    disc_list.each_with_index do |disc, index|
      disc_group = [disc_list[index], disc_list[index + 1], disc_list[index + 2], disc_list[index+ 3]]
      if disc_group.uniq.length == 1
        xy_group = [xy_list[index], xy_list[index+1], xy_list[index+2], xy_list[index+3]]
        xy_group.each do |xy|
          puts xy
          @board[xy[0], xy[1]] = CHECKMARK
        end
      end
    end
  end

  def four_discs?(xy_list, game_symbol)
    counter = 0
    xy_list.each do |slot|
      p slot
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