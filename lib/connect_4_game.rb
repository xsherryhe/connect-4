require_relative './connect_4_player.rb'
require_relative './connect_4_input.rb'

class Game
  include Input

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
    col = valid_input - 1
    @board.reverse.find { |row| row[col] == '   ' }[col] = player.marker
    @curr_player_index ^= 1
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
end
