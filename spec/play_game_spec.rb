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

    context 'player2 inserts into column 3 on top of other disc' do
      it 'should have 2 disks in column 3' do
        player2 = double('Player')
        allow(player2).to receive(:name) {'Murgray'}
        allow(player2).to receive(:game_symbol) {CIRCLE}
        @game.board.board[5,3] = CIRCLE
        allow(@game).to receive(:gets).and_return('3')
        @game.play_round(player2)
        expect(@game.board.board[4,3]).to eq(CIRCLE)
      end
    end

    context 'player1 enters several wrong column responses' do
      it 'should only insert after proper column choice' do
        player1 = double('Player')
        allow(player1).to receive(:name) {'Linda'}
        allow(player1).to receive(:game_symbol) {DOT}
        allow(@game).to receive(:gets).and_return(
          'No', 'Yellow', '#$@#', '-3', '400', '6')
        @game.play_round(player1)
        expect(@game.board.board[5,6]).to eq(DOT)
      end
    end

    context 'player2 tries to insert into full column' do
      it 'should insert after they choose another column' do
        player2 = double('Player')
        allow(player2).to receive(:name) {'Gene'}
        allow(player2).to receive(:game_symbol) {CIRCLE}
        @game.board.board[5,6] = DOT
        @game.board.board[4,6] = DOT
        @game.board.board[3,6] = CIRCLE
        @game.board.board[2,6] = CIRCLE
        @game.board.board[1,6] = CIRCLE
        @game.board.board[0,6] = DOT
        allow(@game).to receive(:gets).and_return('6','6','3')
        @game.play_round(player2)
        expect(@game.board.board[5,3]).to eq(CIRCLE)
      end
    end

    context 'player1 tries full column insert then invalid columns' do
      it 'should insert after they choose a valid column' do
        player1 = double('Player')
        allow(player1).to receive(:name) {'Louise'}
        allow(player1).to receive(:game_symbol) {DOT}
        @game.board.board[5,4] = CIRCLE
        @game.board.board[4,4] = DOT
        @game.board.board[3,4] = CIRCLE
        @game.board.board[2,4] = DOT
        @game.board.board[1,4] = CIRCLE
        @game.board.board[0,4] = DOT
        allow(@game).to receive(:gets).and_return('4','n','#%$','4', '0')
        @game.play_round(player1)
        expect(@game.board.board[5,0]).to eq(DOT)
      end
    end
  end

  
  
  describe '#after_game' do
    context 'win type is a tie' do
      it 'should print "Looks like a tie"' do
        expect do
          @game.after_game(:tie)
        end.to output(a_string_including("Looks like a tie!")).to_stdout
      end
    end

    context 'win type is a player' do
      it 'should print "{player.name} has won"' do
        player2 = double('Player')
        allow(player2).to receive(:name) {'Jason'}
        expect do
          @game.after_game(player2)
        end.to output(a_string_including("#{player2.name} has won!")).to_stdout
      end
    end
  end

  
  
  describe '#play_game' do
    context 'a player wins' do
      it 'should return nothing (nil)' do
        allow(@game).to receive(:win_found?).and_return(true)
        expect(@game.play_game).to be_nil
      end
    end

    context 'board is full' do
      it 'should call after_game method' do
        allow(@game.board).to receive(:full?).and_return(true)
        expect(@game).to receive(:after_game).with(:tie)
        @game.play_game
      end
    end
  end
end