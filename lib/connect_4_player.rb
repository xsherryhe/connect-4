class Player
  attr_reader :name, :marker

  def initialize(index)
    @index = index
    puts "Please input the name of Player #{index + 1}."
    @name = gets.chomp
    @marker = ["\e[31m\u2B24\e[0m", "\e[34m\u2B24\e[0m"][@index]
    puts "#{name}, your marker is #{marker} ."
  end
end
