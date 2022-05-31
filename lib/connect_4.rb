require_relative './connect_4_game.rb'

module Connect4
  def self.run
    loop do
      puts 'Start a new game? (Y/N)'
      unless gets.chomp =~ /yes|y/i
        puts 'Okay, bye!'
        break
      end

      game = Game.new
      game.play
    end
  end
end
