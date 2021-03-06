module GameOver
  def evaluate_game_over
    winner = winning_player
    return unless winner || tie

    display_board
    @game_over = true
    if winner
      puts "#{winner.name} has won the game!"
    else
      puts 'The game ends with a tie.'
    end
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
        rows = row[col..col + 3]
        rows.size == 4 && rows.all? { |slot| slot.include?(player.marker) }
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

  def tie
    @board.none? { |row| row.include?('   ') }
  end
end
