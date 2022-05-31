require_relative './connect_4_game.rb'

module Connect4
  def self.run
    loop do
      puts 'Start a new game? (Y/N)'
      break unless gets.chomp =~ /yes|y/i

      game = Game.new
      game.play
    end
  end
end
