require_relative '../lib/connect_4_game.rb'

describe Game do
  subject(:game) { described_class.new }

  before do
    john = instance_double(Player, name: 'John', marker: "\u25EF")
    mary = instance_double(Player, name: 'Mary', marker: "\u2B24")
    allow(Player).to receive(:new).and_return(john, mary)
  end

  describe '#take_turn' do
    it 'outputs instruction to current player' do
      expect(game).to receive(:puts).with(/John, please select a column to place your token./)
      game.take_turn
    end

    it 'outputs error message while input is not a number' do
      
    end

    it 'outputs error message while input is out of range' do
      
    end

    it 'outputs error message while the selected column is full' do
      
    end

    it 'outputs the appropriate error message depending on the error' do
      
    end

    it 'returns an input that is a valid column number' do
      
    end

    it 'fills one more slot in the selected column' do
      
    end

    it 'switches current player to next player' do
      
    end
  end

  describe '#evaluate_game_over' do
    
  end
end
