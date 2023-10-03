require_relative '../lib/board.rb'
require 'matrix'

RSpec.describe Board do
  before { @board_class = described_class.new }
  DOT = "\u25CF"
  CIRCLE = "\u25CB"

  #PRINT BOARD
  describe '#print_board' do
    context 'board is empty' do
      it 'should print an empty board' do
        @board_class.print_board
      end
    end

    context 'board is partially full' do
      it 'should print a partially filled board' do
        @board_class.board[0,3] =  DOT
        @board_class.board[2,5] =  DOT
        @board_class.board[1,4] =  DOT
        @board_class.board[0,2] =  CIRCLE
        @board_class.board[4,5] =  CIRCLE
        @board_class.board[3,1] =  CIRCLE
        @board_class.print_board
      end
    end

    context 'board is full' do
      it 'should print a full board' do
        @board_class.board.map! {|spot| spot = DOT}
        @board_class.print_board
      end
    end
  end

  #FULL
  describe '#full?' do
    context 'board is empty' do
      it 'should return false' do
        expect(@board_class.full?).to be(false)
      end
    end

    context 'board is partially filled' do
      it 'should return false' do
        @board_class.board[0,2] =  DOT
        @board_class.board[4,5] =  DOT
        @board_class.board[3,1] =  DOT
        expect(@board_class.full?).to be(false)
      end
    end

    context 'board is full' do
      it 'should return true' do
        @board_class.board.map! {|spot| spot = DOT}
        expect(@board_class.full?).to be(true)
      end
    end
  end

  #INSERT
  describe '#insert' do
    context 'first disc is inserted' do
      it 'should have a disc in the first position' do
        @board_class.insert(DOT, 0)
        @board_class.print_board
        expect(@board_class.board[5,0]).to eq(DOT)

      end

      it 'should return [DOT,5,0]' do
        expect(@board_class.insert(DOT, 0)).to eq([DOT,5,0])
      end
    end

    context 'two discs are inserted in one column' do
      it 'should have the two discs in one column' do
        @board_class.insert(DOT, 2)
        @board_class.insert(CIRCLE, 2)
        @board_class.print_board
        expect(@board_class.board[4,2]).to eq(CIRCLE)
      end

      it 'should return return [CIRCLE,4,2]' do
        @board_class.insert(DOT, 2)
        expect(@board_class.insert(CIRCLE, 2)).to eq([CIRCLE, 4,2])
      end
    end

    context 'tries to add disc into full column' do
      it 'should have a full column' do
        5.downto(0) do 
          @board_class.insert(DOT, 4)
        end
        @board_class.print_board
        column4 = @board_class.board.column(4).to_a
        expect(column4.uniq.length).to eq(1)
      end
      
      it 'should return false' do 
        5.downto(0) do 
          @board_class.insert(DOT, 4)
        end
        expect(@board_class.insert(DOT, 4)).to be(nil)
      end
    end
  end

  describe '#win?' do
    #Row tests
    context '4 in a row' do
      it 'should return true' do
        @board_class.board[5,0] =  DOT
        @board_class.board[5,1] =  DOT
        @board_class.board[5,2] =  DOT
        result = @board_class.insert(DOT, 3)
        @board_class.print_board
        expect(@board_class.win?(result[0], result[1], result[2])).to be(true)
        @board_class.print_board
      end
    end

    context '2 in a row, a gap, then 2 more' do
      it 'should return false' do
        @board_class.board[5,0] =  DOT
        @board_class.board[5,1] =  DOT
        @board_class.board[5,2] =  CIRCLE
        @board_class.board[5,3] =  DOT
        result = @board_class.insert(DOT, 4)
        @board_class.print_board
        expect(@board_class.win?(result[0], result[1], result[2])).to be(false)
      end
    end

    context '4 at the end of the row' do
      it 'should return true' do
        @board_class.board[5,6] =  DOT
        @board_class.board[5,5] =  DOT
        @board_class.board[5,4] =  DOT
        result = @board_class.insert(DOT, 3)
        @board_class.print_board
        expect(@board_class.win?(result[0], result[1], result[2])).to be(true)
        @board_class.print_board
      end
    end

    #Column tests
    context '4 in a column' do
      it 'should return true' do
        @board_class.board[5,3] =  DOT
        @board_class.board[4,3] =  DOT
        @board_class.board[3,3] =  DOT
        result = @board_class.insert(DOT, 3)
        @board_class.print_board
        expect(@board_class.win?(result[0], result[1], result[2])).to be(true)
        @board_class.print_board
      end
    end

    context '2 in a column, a gap, then 2 more' do
      it 'should return false' do
        @board_class.board[5,5] =  DOT
        @board_class.board[4,5] =  DOT
        @board_class.board[3,5] =  CIRCLE
        @board_class.board[2,5] =  DOT
        result = @board_class.insert(DOT, 5)
        @board_class.print_board
        expect(@board_class.win?(result[0], result[1], result[2])).to be(false)
      end
    end

    context '4 at top of column' do
      it 'should return true' do
        @board_class.board[5,6] =  DOT
        @board_class.board[4,6] =  DOT
        @board_class.board[3,6] =  CIRCLE
        @board_class.board[2,6] =  CIRCLE
        @board_class.board[1,6] =  CIRCLE
        result = @board_class.insert(CIRCLE, 6)
        @board_class.print_board
        expect(@board_class.win?(result[0], result[1], result[2])).to be(true)
        @board_class.print_board
      end
    end

    #Diagonal wins
    ##Down Diagonal
    context '4 on main diagonal down' do
      it 'should return true' do
        @board_class.board[0,0] =  CIRCLE
        @board_class.board[1,1] =  CIRCLE
        @board_class.board[2,2] =  CIRCLE
        @board_class.board[4,3] =  CIRCLE
        @board_class.board[5,3] =  CIRCLE
        result = @board_class.insert(CIRCLE, 3)
        @board_class.print_board
        expect(@board_class.win?(result[0], result[1], result[2])).to be(true)
        @board_class.print_board
      end
    end

    context '4 on other diagonal down' do
      it 'should return true' do
        @board_class.board[2,0] =  CIRCLE
        @board_class.board[3,1] =  CIRCLE
        @board_class.board[4,2] =  CIRCLE
        result = @board_class.insert(CIRCLE, 3)
        @board_class.print_board
        expect(@board_class.win?(result[0], result[1], result[2])).to be(true)
        @board_class.print_board
      end
    end

    context '4 on end of diagonal down' do
      it 'should return true' do
        @board_class.board[1,3] =  DOT
        @board_class.board[2,4] =  DOT
        @board_class.board[3,5] =  DOT
        @board_class.board[5,6] =  CIRCLE
        result = @board_class.insert(DOT, 6)
        @board_class.print_board
        expect(@board_class.win?(result[0], result[1], result[2])).to be(true)
        @board_class.print_board
      end
    end

    context '2 in diagonal down, a gap, then 2 more' do
      it 'should return false' do
        @board_class.board[0,2] =  CIRCLE
        @board_class.board[1,3] =  CIRCLE
        @board_class.board[2,4] =  DOT
        @board_class.board[3,5] =  CIRCLE
        @board_class.board[5,6] =  DOT
        result = @board_class.insert(CIRCLE, 6)
        @board_class.print_board
        expect(@board_class.win?(result[0], result[1], result[2])).to be(false)
      end
    end

    context 'only 3 in diagonal down' do
      it 'should return false' do
        @board_class.board[3,1] =  CIRCLE
        @board_class.board[4,2] =  CIRCLE
        result = @board_class.insert(CIRCLE, 3)
        @board_class.print_board
        expect(@board_class.win?(result[0], result[1], result[2])).to be(false)
      end
    end

    ##Up Diagonals
    context '4 on main diagonal up' do
      it 'should return true' do
        @board_class.board[2,3] =  DOT
        @board_class.board[3,2] =  DOT
        @board_class.board[4,1] =  DOT
        result = @board_class.insert(DOT, 0)
        @board_class.print_board
        expect(@board_class.win?(result[0], result[1], result[2])).to be(true)
        @board_class.print_board
      end
    end

    context '4 on other diagonal up' do
      it 'should return true' do
        @board_class.board[2,5] =  CIRCLE
        @board_class.board[3,4] =  CIRCLE
        @board_class.board[4,3] =  CIRCLE
        result = @board_class.insert(CIRCLE, 2)
        @board_class.print_board
        expect(@board_class.win?(result[0], result[1], result[2])).to be(true)
        @board_class.print_board
      end
    end

    context '4 on end of diagonal up' do
      it 'should return true' do
        @board_class.board[0,4] =  DOT
        @board_class.board[1,3] =  DOT
        @board_class.board[2,2] =  DOT
        @board_class.board[5,1] =  CIRCLE
        @board_class.board[4,1] =  CIRCLE
        result = @board_class.insert(DOT, 1)
        @board_class.print_board
        expect(@board_class.win?(result[0], result[1], result[2])).to be(true)
        @board_class.print_board
      end
    end

    context '2 in diagonal up, a gap, then 2 more' do
      it 'should return false' do
        @board_class.board[0,5] =  CIRCLE
        @board_class.board[1,4] =  CIRCLE
        @board_class.board[2,3] =  DOT
        @board_class.board[3,2] =  CIRCLE
        @board_class.board[5,1] =  DOT
        result = @board_class.insert(CIRCLE, 1)
        @board_class.print_board
        expect(@board_class.win?(result[0], result[1], result[2])).to be(false)
      end
    end

    context 'only 3 in diagonal up' do
      it 'should return false' do
        @board_class.board[3,5] =  CIRCLE
        @board_class.board[4,4] =  CIRCLE
        result = @board_class.insert(CIRCLE, 3)
        @board_class.print_board
        expect(@board_class.win?(result[0], result[1], result[2])).to be(false)
      end
    end
  end
end