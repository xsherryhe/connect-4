require_relative '../lib/connect_4_game.rb'

describe Game do
  subject(:game) { described_class.new }
  let(:board) { game.instance_variable_get(:@board) }
  let(:board_config) do
    random_board = Array.new(6) { Array.new(7, '   ') }
    random_board.reverse.each_with_index do |row, i|
      row.map!.with_index do |slot, j|
        (i.zero? || random_board[6 - i][j] == 'X') && rand(10) < 5 ? 'X' : slot
      end
    end
    random_board
  end
  let(:random_column_input) { rand(1..7).to_s }
  let(:random_player_index) { rand(2) }
  let(:random_player_name) { %w[John Mary][random_player_index] }
  let(:random_player_marker) { [" \e[31m\u2B24\e[0m ", " \e[34m\u2B24\e[0m "][random_player_index] }

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
    before do
      allow(game).to receive(:puts)
      game.instance_variable_set(:@curr_player_index, random_player_index)
    end

    10.times do
      it 'outputs instruction to current player' do
        allow(game).to receive(:gets).and_return(random_column_input)
        expect(game).to receive(:puts).with("#{random_player_name}, please enter a column number to place your token.")
        game.take_turn
      end

      it 'outputs error message while input is not a number' do
        allow(game).to receive(:gets).and_return('d', '@', '*', '(()))', 'hello world', random_column_input)
        expect(game).to receive(:puts).with('Please enter a column number between 1 and 7.').exactly(5).times
        game.take_turn
      end

      it 'outputs error message while input is out of range' do
        allow(game).to receive(:gets).and_return('24', '0', '8', random_column_input)
        expect(game).to receive(:puts).with('Please enter a column number between 1 and 7.').exactly(3).times
        game.take_turn
      end

      it 'outputs error message while the selected column is full' do
        filled_column = rand(1..7)
        board_config.each { |row| row[filled_column - 1] = 'X' }
        unfilled_column = ((1..7).to_a - [filled_column]).sample
        board_config[0][unfilled_column - 1] = '   '
        game.instance_variable_set(:@board, board_config)
        allow(game).to receive(:gets).and_return(filled_column.to_s, unfilled_column.to_s)
        expect(game).to receive(:puts).with('The column you selected is full. Please select a different column number.').once
        game.take_turn
      end

      it 'outputs the appropriate error message depending on the error' do
        filled_column = rand(1..7)
        board_config.each { |row| row[filled_column - 1] = 'X' }
        unfilled_column = ((1..7).to_a - [filled_column]).sample
        board_config[0][unfilled_column - 1] = '   '
        game.instance_variable_set(:@board, board_config)
        allow(game).to receive(:gets).and_return(filled_column.to_s, filled_column.to_s, 'foo', filled_column.to_s, '37', unfilled_column.to_s)
        expect(game).to receive(:puts).with('The column you selected is full. Please select a different column number.').exactly(3).times
        expect(game).to receive(:puts).with('Please enter a column number between 1 and 7.').twice
        game.take_turn
      end

      it 'fills a slot in the selected column number' do
        board_config[0][random_column_input.to_i - 1] = '   '
        game.instance_variable_set(:@board, Array.new(6) { |i| board_config[i].dup })
        allow(game).to receive(:gets).and_return(random_column_input)
        game.take_turn
        next_row = board_config.rindex { |row| row[random_column_input.to_i - 1] == '   ' }
        board_config[next_row][random_column_input.to_i - 1] = random_player_marker
        expect(board).to eq(board_config)
      end

      it 'switches next player to current player' do
        allow(game).to receive(:gets).and_return(random_column_input)
        game.take_turn
        index = game.instance_variable_get(:@curr_player_index)
        expect(index).to eq([1, 0][random_player_index])
      end
    end
  end

  describe '#evaluate_game_over' do
    let(:game_over) { game.instance_variable_get(:@game_over) }
    before do
      allow(game).to receive(:puts)
      game.instance_variable_set(:@curr_player_index, random_player_index)
    end

    context 'when there is no win or tie' do
      10.times do
        it 'does not change the game to be over' do
          board_config[0][random_column_input.to_i - 1] = '   '
          game.instance_variable_set(:@board, board_config)
          game.evaluate_game_over
          expect(game_over).not_to be true
        end
      end
    end

    context 'when a player wins horizontally' do
      before do
        row = rand(6)
        start_col = rand(4)
        (start_col..start_col + 3).each { |col| board_config[row][col] = random_player_marker }
        game.instance_variable_set(:@board, board_config)
      end

      10.times do
        it 'changes the game to be over' do
          game.evaluate_game_over
          expect(game_over).to be true
        end

        it "outputs a win message with the winning player's name" do
          expect(game).to receive(:puts).with("#{random_player_name} has won the game!")
          game.evaluate_game_over
        end
      end
    end

    context 'when a player wins vertically' do
      before do
        start_row = rand(3)
        (start_row..start_row + 3).each { |row| board_config[row][random_column_input.to_i - 1] = random_player_marker }
        game.instance_variable_set(:@board, board_config)
      end

      10.times do
        it 'changes the game to be over' do
          game.evaluate_game_over
          expect(game_over).to be true
        end

        it "outputs a win message with the winning player's name" do
          expect(game).to receive(:puts).with("#{random_player_name} has won the game!")
          game.evaluate_game_over
        end
      end
    end

    context 'when a player wins diagonally' do
      before do
        row = rand(6)
        col = rand(7)
        row_change, col_change = [row, col].map { |num| num < 3 ? 1 : -1 }
        4.times do
          board_config[row][col] = random_player_marker
          row += row_change
          col += col_change
        end
        game.instance_variable_set(:@board, board_config)
      end

      10.times do
        xit 'changes the game to be over' do
          game.evaluate_game_over
          expect(game_over).to be true
        end

        xit "outputs a win message with the winning player's name" do
          expect(game).to receive(:puts).with("#{random_player_name} has won the game!")
          game.evaluate_game_over
        end
      end
    end

    context 'when the game is tied (all columns full)' do
      before do
        tie_board = Array.new(6) do |i|
          player_index = i.even? ? random_player_index : random_player_index ^ 1
          Array.new(7) do
            player_index ^= 1
            [" \e[31m\u2B24\e[0m ", " \e[34m\u2B24\e[0m "][player_index]
          end
        end
        game.instance_variable_set(:@board, tie_board)
      end

      xit 'changes the game to be over' do
        game.evaluate_game_over
        expect(game_over).to be true
      end

      xit 'outputs a tie message' do
        expect(game).to receive(:puts).with('The game ends with a tie.')
        game.evaluate_game_over
      end
    end
  end
end
