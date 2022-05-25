require_relative './connect_4_player.rb'

class Game
  def initialize
    @players = [0, 1].map { |index| Player.new(index) }
    @board = Array.new(6) { Array.new(7, '   ') }
    @curr_player_index = 0
  end

  def play
    until @game_over
      take_turn
      evaluate_game_over
    end
  end

  def take_turn
    player = @players[@curr_player_index]
    display_board
    puts "#{player.name}, please enter a column number to place your token."
    col_ind = valid_input - 1
  end

  def evaluate_game_over
  end

  private

  def display_board
    row_barrier = "\r\n+#{(['---'] * 7).join('+')}+\r\n"
    puts row_barrier.tr('-', ' ') +
         @board.map { |row| "|#{row.join('|')}|" }.join(row_barrier) +
         row_barrier +
         " #{(1..7).map { |num| " #{num} " }.join(' ')} "
  end

  def valid_input
    input = gets.chomp.to_i
    while out_range(input) || filled_column(input)
      puts out_range(input) ? range_error : filled_column_error
      input = gets.chomp.to_i
    end
    input
  end

  def out_range(input)
    input < 1 || input > 7
  end

  def filled_column(input)
    @board.none? { |row| row[input - 1] == '   ' }
  end

  def range_error
    'Please enter a column number between 1 and 7.'
  end

  def filled_column_error
    'The column you selected is full. Please select a different column number.'
  end
end
