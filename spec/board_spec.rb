require_relative '../lib/board.rb'
require 'matrix'

RSpec.describe Board do
  before { @board_class = described_class.new }
  DOT = "\u25CF"
  CIRCLE = "\u25CB"

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

  describe '#insert?' do
    context 'first disc is inserted' do
      it 'should have a disc in the first position' do
        @board_class.insert?(DOT, 0)
        @board_class.print_board
        expect(@board_class.board[5,0]).to eq(DOT)

      end

      it 'should return true' do
        expect(@board_class.insert?(DOT, 0)).to be true
      end
    end

    context 'two discs are inserted in one column' do
      it 'should have the two discs in one column' do
        @board_class.insert?(DOT, 2)
        @board_class.insert?(CIRCLE, 2)
        @board_class.print_board
        expect(@board_class.board[4,2]).to eq(CIRCLE)
      end

      it 'should return true' do
        expect(@board_class.insert?(DOT, 0)).to be true
      end
    end

    context 'tries to add disc into full column' do
      it 'should have a full column' do
        5.downto(0) do 
          @board_class.insert?(DOT, 4)
        end
        expect(@board_class.insert?(DOT, 4)).to be(false)
      end
      it 'should return false' do 
        5.downto(0) do 
          @board_class.insert?(DOT, 4)
        end
        @board_class.print_board
        expect(@board_class.insert?(DOT, 4)).to be(false)
      end
    end
  end
end