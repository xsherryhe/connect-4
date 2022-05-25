module Input
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
