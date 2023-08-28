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
end