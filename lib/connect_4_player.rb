class Player
  attr_reader :name, :marker, :index

  def initialize(index)
    @index = index
    puts "Please input the name of Player #{index}."
    @name = gets.chomp
    @marker = ["\e[31m\u2B24\e[0m", "\e[34m\u2B24\e[0m"][index - 1]
    puts "Player #{index}, your marker is #{marker} ."
  end
end
