class Player
  attr_reader :name, :colour

  def initialize(name, colour)
    @name = name
    @colour = colour
  end

  def get_move
    puts "\n #{@name}, please enter your move (eg 'a1 to b2')"
    player_move = convert_input_to_move(gets.chomp)
    while !player_move
      puts "\nthat doesnt seem right.\nEnter your move in this format ('a1 to b2')"
      player_move = convert_input_to_move(gets.chomp)
    end
    player_move
  end

  def convert_input_to_move(input)
    player_move = regex_scan(input).map { |e| convert(e) }
    valid_input?(player_move) ? player_move : false
  end

  def regex_scan(input)
    input.scan(/[a-hA-H][0-7]/) # leaves you with a1a2
  end

  #convert to move form
  def convert(input)
    row = input[1].to_i
    column = convert_column(input[0])
    [row, column]
  end

  def convert_column(letter)
    columns = {"A" => 0, "B" => 1, "C" => 2, "D" => 3, "E" => 4, "F" => 5, "G" => 6, "H" => 7}
    columns[letter.upcase] #get the value of the hash
  end

  def valid_input?(player_move)
    player_move.length == 2 && player_move.each { |move| move.length == 2 && move.each { |e| (0..7).include?(e) } }
  end

  def get_pawn_promotion
    puts "\n#{@name}, you can upgrade your pawn"
    puts "choose: Queen, Knight, Bishop or Rook"
    upgrade = gets.chomp.capitalize
    while !valid_pawn_promotion?(upgrade)
      puts "\nPlease select from the following list:"
      puts "Queen, Knight, Bishop or Rook"
      upgrade = gets.chomp.upcase
    end
    upgrade
  end

  def valid_pawn_promotion?(input)
    answers = ["Queen", "Knight", "Bishop", "Rook"]
    answers.include?(input)
  end

end
