require_relative '../lib/connect_4_game.rb'

describe Game do
  subject(:game) { described_class.new }

  before do
    john = instance_double(Player, name: 'John', marker: "\u25EF")
    mary = instance_double(Player, name: 'Mary', marker: "\u2B24")
    allow(Player).to receive(:new).and_return(john, mary)
  end

  describe '#initialize' do
    it 'initializes two new players' do
      expect(Player).to receive(:new).twice
      game
    end

    it 'creates a board with an array of 6 rows and 7 columns' do
      board = game.instance_variable_get(:@board)
      expect(board).to eq([['   '] * 7] * 6)
    end
  end

  describe '#play' do
    context 'when the game is over' do
      it 'does not execute the loop' do
        game.instance_variable_set(:@game_over, true)
        expect(game).not_to receive(:take_turn)
        game.play
      end
    end

    context 'when the game is over after one loop' do
      it 'executes the loop only once' do
        allow(game).to receive(:evaluate_game_over) { game.instance_variable_set(:@game_over, true) }
        expect(game).to receive(:take_turn).once
        game.play
      end
    end

    context 'when the game is over after two loops' do
      it 'executes the loop exactly twice' do
        call_count = 0
        allow(game).to receive(:evaluate_game_over) do
          call_count += 1
          game.instance_variable_set(:@game_over, true) if call_count == 2
        end
        expect(game).to receive(:take_turn).twice
        game.play
      end
    end
  end

  describe '#take_turn' do
    before do
      allow(game).to receive(:puts)
    end

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
