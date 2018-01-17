
class Game
  def initialize(player1 = "player 1", player2 = "player 2")
    @player1 = Player.new(player1, "white")
    @player2 = Player.new(player2, "black")
    @board = Board.new
    @active_player = @player1
  end

  def play
    puts "\n Welcome to chess. #{@player1.name} you're white, #{@player2.name} you're black"

    @board.display_board

    play_turn

    puts "hope you had fun"
    exit
  end


  def game_over?
    if @board.check_mate?(@active_player.colour)
      puts "\nCheckmate! #{@active_player.colour} you lose this round."
    end
  end

  def switch_players(active_player)
    (@active_player == @player1) ? (@active_player = @player2) : (@active_player = @player1)
  end


  def play_turn

    loop do
      break if game_over?
      break if stalemate?

      puts "\n\n #{@active_player.name}, it's your turn. (#{@active_player.colour}'s turn).\n"
      @board.display_board
      check_if_checked?

      #select_which_piece
      start_sq = get_starting_location
      end_sq = get_ending_location

      until (@board.valid_move?(start_sq[0], start_sq[1], end_sq[0], end_sq[1])) && @board.check?(@board.locate_king(@active_player.colour).location, @active_player.colour) == false
        puts "That's not a valid move. please try again \n"
        @board.display_board
        start_sq = get_starting_location
        end_sq = get_ending_location
      end

      @board.move_piece(start_sq[0], start_sq[1], end_sq[0], end_sq[1])

      @active_player = switch_players(@active_player)
    end
  end


  def stalemate?
    king = @board.locate_king(@active_player.colour)
    return false if @board.check?(king.location, king.colour)
    if @board.can_player_avoid_stalemate?(@active_player.colour) == false
      puts "\nClose game. It has ended in a stalemate."
    end
  end

  def check_if_checked?
    king = @board.locate_king(@active_player.colour)
    if @board.check?(king.location, king.colour)
      puts "\n#{@active_player.name}, your king is in check!"
    end
  end


  def get_starting_location
    puts "\n#{@active_player.colour}, Which piece would you like to move?"
    starting_location = gets.strip.split(",").map(&:to_i)
    until @board.piece_is_players_piece?(starting_location, @active_player.colour)
      puts "\nHey, that's not a valid piece. please try again"
      starting_location = gets.strip.split(",").map { |coord| coord.to_i}
    end
    starting_location
  end

  def get_ending_location
    puts "\nwhere would you like to move your piece?"
    ending_location = gets.strip.split(",").map(&:to_i)
  end

end
