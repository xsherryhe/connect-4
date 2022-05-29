module GameOver
  def evaluate_game_over
    return unless horizontal_winning_player

    @game_over = true
    puts "#{horizontal_winning_player.name} has won the game!"
  end

  private

  def horizontal_winning_player
    @players.find do |player|
      @board.any? do |row|
        (0..3).any? do |col|
          row[col..col + 3].all? { |slot| slot.include?(player.marker) }
        end
      end
    end
  end
end
