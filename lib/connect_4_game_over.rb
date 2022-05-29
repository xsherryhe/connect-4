module GameOver
  def evaluate_game_over
    return unless winning_player

    @game_over = true
    puts "#{winning_player.name} has won the game!"
  end

  private

  def winning_player
    @players.find do |player|
      [@board, @board.transpose].any? do |config|
        config.any? do |row|
          (0..3).any? do |col|
            row[col..col + 3].all? { |slot| slot.include?(player.marker) }
          end
        end
      end
    end
  end
end
