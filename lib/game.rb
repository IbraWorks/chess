
class Game
  def initialize(player1 = "player 1", player2 = "player 2")
    @player1 = Player.new(player1, "white")
    @player2 = Player.new(player2, "black")
    @board = Board.new
    @active_player = @player1
    @title = Title.new
  end

  def play
    @title.title
    puts "\n\n Welcome to chess. #{@player1.name} you're white, #{@player2.name} you're black"
    @title.instructions

    @board.display_board

    play_turn

    puts "hope you had fun. nobody is gonna play this. don't even know why im writing this"
    exit
  end


  def game_over?
    if @board.check_mate?(@active_player.colour)
      puts "\nCheckmate! #{@active_player.colour} you lose this round."
      @board.display_board
      true
    end
  end

  def switch_players(active_player)
    (@active_player == @player1) ? (@active_player = @player2) : (@active_player = @player1)
  end


  def play_turn

    loop do
      break if game_over?
      break if is_it_stalemate?

      puts "\n#{@active_player.name}, it's your turn. (#{@active_player.colour}'s turn).\n"
      @board.display_board
      check_if_checked?

      #select_which_piece
      player_move = @active_player.get_move
      start_sq = player_move[0]
      end_sq = player_move[1]

      if !@board.valid_move?(start_sq[0], start_sq[1], end_sq[0], end_sq[1]) && @board.check_own_king?(start_sq, end_sq, @active_player.colour) == false
        puts "That's not a valid move. please try again \n"
        redo
      end

      @board.move_piece(start_sq[0], start_sq[1], end_sq[0], end_sq[1])

      #to do: check_for_pawn_promotion after

      @active_player = switch_players(@active_player)
    end
  end

  def is_it_stalemate?
    if @board.stalemate?(@active_player.colour)
      puts "\nClose game. It has ended in a stalemate."
      true
    end
  end

  def check_if_checked?
    king = @board.locate_king(@active_player.colour)
    if @board.check?(king.location, @active_player.colour)
      puts "\n#{@active_player.name}, your king is in check!"
    end
  end

end
