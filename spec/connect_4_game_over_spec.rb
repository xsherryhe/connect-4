require_relative '../lib/connect_4_game.rb'

describe Game do
  subject(:game) { described_class.new }
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

    context 'when the game is tied (all columns full)' do
      before do
        tie_board = Array.new(6) do |i|
          player_index = i.even? ? random_player_index : random_player_index ^ 1
          Array.new(7) do |j|
            player_index ^= 1 if j.even?
            [" \e[31m\u2B24\e[0m ", " \e[34m\u2B24\e[0m "][player_index]
          end
        end
        game.instance_variable_set(:@board, tie_board)
      end

      it 'changes the game to be over' do
        game.evaluate_game_over
        expect(game_over).to be true
      end

      it 'outputs a tie message' do
        expect(game).to receive(:puts).with('The game ends with a tie.')
        game.evaluate_game_over
      end
    end
  end
end
