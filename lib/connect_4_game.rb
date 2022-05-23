require_relative './connect_4_player.rb'

class Game
  def initialize
    @players = [1, 2].map { |index| Player.new(index) }
    @board = Array.new(6) { Array.new(7, '   ') }
  end

  def take_turn
    display_board
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

game = Game.new
game.take_turn
