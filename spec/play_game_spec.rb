require_relative '../lib/play_game.rb'
require 'matrix'

RSpec.describe PlayGame do
  before { @game = described_class.new }
  DOT = "\u25CF"
  CIRCLE = "\u25CB"

  describe '#get_names' do
    context 'player1 enters name then confirms it' do
      it 'should return the player 1 name' do
        allow(@game).to receive(:gets).and_return("Bob\n", "Y\n")
        expect(@game.get_names(1)).to eq("Bob")
      end
    end

    context 'player2 enters name then changes it' do
      it 'should return the second player 2 name' do
        allow(@game).to receive(:gets).and_return("Mumu\n", "n\n", "Linda\n", "Y\n")
        expect(@game.get_names(2)).to eq("Linda")
      end
    end

    context 'player1 enters invalid text for name confirmation' do
      it 'should still return the first name after eventual yes' do
        allow(@game).to receive(:gets).and_return(
          "Bob\n", "kdyfj\n", "2836%(^*\n", "banana34\n", "Y\n")
        expect(@game.get_names(1)).to eq("Bob")
      end
    end
  end

  describe '#play_round' do
    context 'player1 chooses column 5' do
      it 'should have a disk added to column 5' do
        player1 = double('Player')
        allow(player1).to receive(:name) {'Bob'}
        allow(player1).to receive(:game_symbol) {DOT}
        allow(@game).to receive(:gets).and_return('5')

        @game.play_round(player1)
        expect(@game.board.board[5,5]).to eq(DOT)
      end
    end
  end
end