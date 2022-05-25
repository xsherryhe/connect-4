require_relative '../lib/connect_4_game.rb'

describe Game do
  subject(:game) { described_class.new }
  let(:board) { game.instance_variable_get(:@board) }

  before do
    john = instance_double(Player, name: 'John', marker: "\e[31m\u2B24\e[0m")
    mary = instance_double(Player, name: 'Mary', marker: "\e[34m\u2B24\e[0m")
    allow(Player).to receive(:new).and_return(john, mary)
  end

  describe '#initialize' do
    it 'initializes two new players' do
      expect(Player).to receive(:new).twice
      game
    end

    it 'creates a board with an array of 6 rows and 7 columns' do
      expect(board).to eq([['   '] * 7] * 6)
    end
  end

  describe '#play' do
    before do
      allow(game).to receive(:take_turn)
      allow(game).to receive(:evaluate_game_over)
    end

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
    let(:expected_board) { Array.new(6) { Array.new(7, '   ') } }

    before do
      allow(game).to receive(:puts)
    end

    it 'outputs instruction to current player' do
      allow(game).to receive(:gets).and_return('5')
      expect(game).to receive(:puts).with(/John, please enter a column number to place your token./)
      game.take_turn
    end

    it 'outputs error message while input is not a number' do
      allow(game).to receive(:gets).and_return('d', '@', '*', '(()))', 'hello world', '5')
      expect(game).to receive(:puts).with(/Please enter a column number between 1 and 7./).exactly(5).times
      game.take_turn
    end

    it 'outputs error message while input is out of range' do
      allow(game).to receive(:gets).and_return('24', '0', '8', '5')
      expect(game).to receive(:puts).with(/Please enter a column number between 1 and 7./).exactly(3).times
      game.take_turn
    end

    it 'outputs error message while the selected column is full' do
      game.instance_variable_set(:@board, [['   '] * 6 + ['X']] * 6)
      allow(game).to receive(:gets).and_return('7', '6')
      expect(game).to receive(:puts).with(/The column you selected is full. Please select a different column number./).once
      game.take_turn
    end

    it 'outputs the appropriate error message depending on the error' do
      game.instance_variable_set(:@board, [['X'] + ['   '] * 6] * 6)
      allow(game).to receive(:gets).and_return('1', '1', 'foo', '1', '37', '5')
      expect(game).to receive(:puts).with(/The column you selected is full. Please select a different column number./).exactly(3).times
      expect(game).to receive(:puts).with(/Please enter a column number between 1 and 7./).twice
      game.take_turn
    end

    context 'when the selected column is a middle column' do
      it 'fills a slot in the selected column number' do
        allow(game).to receive(:gets).and_return('5')
        game.take_turn
        expected_board[5][4] = "\e[31m\u2B24\e[0m"
        expect(board).to eq(expected_board)
      end
    end

    context 'when the selected column is the first column' do
      it 'fills a slot in the first column' do
        allow(game).to receive(:gets).and_return('1')
        game.take_turn
        expected_board[5][0] = "\e[31m\u2B24\e[0m"
        expect(board).to eq(expected_board)
      end
    end

    context 'when the selected column is the last column' do
      it 'fills a slot in the last column' do
        allow(game).to receive(:gets).and_return('7')
        game.take_turn
        expected_board[5][6] = "\e[31m\u2B24\e[0m"
        expect(board).to eq(expected_board)
      end
    end

    context 'when the selected column is partly filled' do
      it 'fills the next slot in the selected column' do
        bottom_2 = expected_board.last(2)
        p bottom_2
        bottom_2.each { |row| row[3] = 'X' }
        p expected_board
        game.instance_variable_set(:@board, expected_board)
        allow(game).to receive(:gets).and_return('4')
        game.take_turn
        expected_board[3][3] = "\e[31m\u2B24\e[0m"
        expect(board).to eq(expected_board)
      end
    end

    it 'switches next player to current player' do
      game.take_turn
      index = game.instance_variable_get(:@curr_player_index)
      expect(index).to eq(1)
    end

    context 'when the current player is the second player' do
      before do
        game.instance_variable_set(:@curr_player_index, 1)
      end

      it "outputs instruction with the correct current player's name" do
        expect(game).to receive(:puts).with(/Mary, please enter a column number to place your token./)
        game.take_turn
      end

      it "fills the slot with the correct current player's marker" do
        allow(game).to receive(:gets).and_return('6')
        game.take_turn
        expected_board[5][5] = "\e[34m\u2B24\e[0m"
        expect(board).to eq(expected_board)
      end

      it 'switches next player to current player' do
        game.take_turn
        index = game.instance_variable_get(:@curr_player_index)
        expect(index).to eq(0)
      end
    end
  end

  describe '#evaluate_game_over' do
    
  end
end
