
RSpec.describe Board do
  before { @board = described_class.new }

  describe '#full?' do
    context 'board is empty' do
      it 'should return false' do
        expect(@board.full?).to be(false)
      end
    end
  end
end