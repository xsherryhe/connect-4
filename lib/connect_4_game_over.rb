module GameOver
  def evaluate_game_over
    return unless winning_player

    display_board
    @game_over = true
    puts "#{winning_player.name} has won the game!"
  end

  private

  def winning_player
    @players.find { |player| straight_winning(player) || diag_winning(player) }
  end

  def straight_winning(player)
    [@board, @board.transpose].any? { |config| winning_config(config, player) }
  end

  def winning_config(config, player)
    config.any? do |row|
      (0..3).any? do |col|
        row[col..col + 3].all? { |slot| slot.include?(player.marker) }
      end
    end
  end

  def diag_winning(player)
    (0..3).any? do |row|
      (0..6).any? { |col| winning_slot(row, col, player) }
    end
  end

  def winning_slot(row, col, player)
    [-1, 1].any? do |dir|
      (0..3).all? do |change|
        new_row = row + change
        new_col = col + change * dir
        new_row.between?(0, 5) && new_col.between?(0, 6) &&
          @board[new_row][new_col].include?(player.marker)
      end
    end
  end
end
