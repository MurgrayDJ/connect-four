require_relative '../lib/board.rb'
require 'matrix'

RSpec.describe Board do
  before { @board_class = described_class.new }



  describe '#print_board' do
    context 'board is empty' do
      it 'should print an empty board' do
        @board_class.print_board
      end
    end

    context 'board is partially full' do
      it 'should print a partially filled board' do
        @board_class.board[0,3] =  "\u25CF"
        @board_class.board[2,5] =  "\u25CF"
        @board_class.board[1,4] =  "\u25CF"
        @board_class.board[0,2] =  "\u25CB"
        @board_class.board[4,5] =  "\u25CB"
        @board_class.board[3,1] =  "\u25CB"
        @board_class.print_board
      end
    end

    context 'board is full' do
      it 'should print a full board' do
        @board_class.board.map! {|spot| spot = "\u25CF"}
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
        @board_class.board[0,2] =  "\u25CF"
        @board_class.board[4,5] =  "\u25CF"
        @board_class.board[3,1] =  "\u25CF"
        expect(@board_class.full?).to be(false)
      end
    end

    context 'board is full' do
      it 'should return true' do
        @board_class.board.map! {|spot| spot = "\u25CF"}
        expect(@board_class.full?).to be(true)
      end
    end
  end

  describe '#insert' do
    context 'first disc is inserted' do
      it 'should have a disc in the first position' do
        @board_class.insert("\u25CF", 0)
        @board_class.print_board
        expect(@board_class.board[5,0]).to eq("\u25CF")
      end
    end

    context 'two discs are inserted in one column' do
      it 'should have the two discs in one column' do
        @board_class.insert("\u25CF", 2)
        @board_class.insert("\u25CB", 2)
        @board_class.print_board
        expect(@board_class.board[4,2]).to eq("\u25CB")
      end
    end
  end
end