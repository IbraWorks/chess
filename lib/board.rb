require_relative "bishop.rb"
require_relative "game.rb"
require_relative "king.rb"
require_relative "knight.rb"
require_relative "pawn.rb"
require_relative "piece.rb"
require_relative "queen.rb"
require_relative "rook.rb"

class Board
attr_reader :game_board

  def initialize
    @game_board = Array.new(8) {Array.new(8, " ") }

    @game_board[0][0] = Rook.new([0,0], "black")
    @game_board[0][1] = Knight.new([0,1], "black")
    @game_board[0][2] = Bishop.new([0,2], "black")
    @game_board[0][3] = Queen.new([0,3], "black")
    @game_board[0][4] = King.new([0,4], "black")
    @game_board[0][5] = Bishop.new([0,5], "black")
    @game_board[0][6] = Knight.new([0,6], "black")
    @game_board[0][7] = Rook.new([0,7], "black")

    @game_board[7][0] = Rook.new([7,0], "white")
    @game_board[7][1] = Knight.new([7,1], "white")
    @game_board[7][2] = Bishop.new([7,2], "white")
    @game_board[7][3] = Queen.new([7,3], "white")
    @game_board[7][4] = King.new([7,4], "white")
    @game_board[7][5] = Bishop.new([7,5], "white")
    @game_board[7][6] = Knight.new([7,6], "white")
    @game_board[7][7] = Rook.new([7,7], "white")

    0.upto(7) {|y| @game_board[6][y] = Pawn.new([6,y], "white")}
    0.upto(7) {|y| @game_board[1][y] = Pawn.new([1,y], "black")}

    0.upto(7) {|y| @game_board[5][y] = nil}
    0.upto(7) {|y| @game_board[4][y] = nil}
    0.upto(7) {|y| @game_board[3][y] = nil}
    0.upto(7) {|y| @game_board[2][y] = nil}
  end

  def display_board
    print "  "
    8.times.each{ print "+----"}
    puts "+"
    @game_board.each_index do |row|
      print "#{row} "
      @game_board[row].each_index do |column|
        print "| #{@game_board[row][column]}  "
      end
      puts "|"
      print "  "
      8.times.each {print "+----"}
      puts "+"
    end
    print "  "
    (0..7).each {|e| print "  #{e}  "}
    puts ""
  end

  #take the starting and ending coord, and instantiate a new object on the
  #ending coord using the instance variables from the starting one.
  #then make the starting coord == nil
  def move_piece(start_x, start_y, end_x, end_y)
    piece = @game_board[start_x][start_y]

    @game_board[end_x][end_y] = piece.class.new([end_x, end_y], piece.colour)
    @game_board[start_x][start_y] = nil

    moved_piece = @game_board[end_x][end_y]
    if moved_piece.class == Pawn
      pawn_specials(moved_piece, start_x, end_y)
    end

    turn_off_enpassant(piece.colour) #once a move has been made, disallow enpassant on enemy pawns.
  end

  def piece_is_players_piece?(location, colour)
    return false if !location.all? {|coord| coord.between?(0,7)}
    piece = @game_board[location[0]][location[1]]
    if (piece != nil) && (piece.colour == colour)
      return true
    else
      return false
    end
  end

  #check if piece exists on starting sq. check if piece can move to target sq.
  #check if target sq is empty or has enemy piece
  #check if pieces are in between. check for pawn difficulties
  def valid_move?(start_x, start_y, end_x, end_y)
    return false if start_x > 7 || start_x < 0
    return false if start_y > 7 || start_y < 0
    return false if end_x > 7 || end_x < 0
    return false if end_y > 7 || end_y < 0
    piece = @game_board[start_x][start_y]
    return false if piece == nil

    target_sq = [end_x, end_y]
    return false unless piece.moves.include?(target_sq)

    return valid_pawn_move?(piece, target_sq, end_y, start_y) if piece.class == Pawn

    return false unless empty_sq?(target_sq) || enemy_at_sq?(piece.colour, target_sq)

    unless piece.class == King || piece.class == Knight
      return no_pieces_in_between?(start_x, start_y, end_x, end_y)
    end

    true
  end

  def move_checks_own_king?(start_x, start_y, end_x, end_y, colour)
    current_board = Marshal.load(Marshal.dump(@game_board))

    move_piece(start_x, start_y, end_x, end_y)

    king = locate_king(colour)

    if check?(king.location, king.colour)
      @game_board = current_board
      return true
    else
      @game_board = current_board
      return false
    end
  end

  def can_player_avoid_stalemate?(colour)
    potential_moves = []
    friendlies = friendly_pieces(colour)

    friendlies.each do |friendly|
      valid_moves = all_valid_moves(friendly.location, friendly.moves)
      valid_moves.each do |move|
        if !move_checks_own_king?(friendly.location[0], friendly.location[1], move[0], move[1], colour)
          potential_moves << move
        end
      end
    end
    potential_moves.empty? ? false : true
  end

  def no_pieces_in_between?(start_x, start_y, end_x, end_y)
    if start_x == end_x
      starting_column = start_y < end_y ? start_y : end_y
      ending_column = starting_column == start_y ? end_y : start_y
      starting_column += 1
      until starting_column == ending_column
        return false unless @game_board[start_x][starting_column] == nil
        starting_column += 1
      end
      true
    elsif start_y == end_y
      starting_row = start_x < end_x ? start_x : end_x
      ending_row = starting_row == start_x ? end_x : start_x
      starting_row += 1
      until starting_row == ending_row
        return false unless @game_board[starting_row][start_y] == nil
        starting_row += 1
      end
      true
    else
      no_pieces_in_between_diagonal?(start_x, start_y, end_x, end_y)
    end
  end

  # Given two points on the board that form a diagonal, returns true
  # if there are no pieces in between and false otherwise
  def no_pieces_in_between_diagonal?(start_x, start_y, end_x, end_y)
    row = start_x
    column = start_y
    if end_x > start_x && end_y > start_y
      row += 1
      column += 1
      until row == end_x
        return false unless @game_board[row][column] == nil
        row += 1
        column += 1
      end
    elsif end_x > start_x && end_y <= start_y
      row += 1
      column -= 1
      until row == end_x
        return false unless @game_board[row][column] == nil
        row += 1
        column -= 1
      end
    elsif end_x <= start_x && end_y <= start_y
      row -= 1
      column -= 1
      until row == end_x
        return false unless @game_board[row][column] == nil
        row -= 1
        column -= 1
      end
    elsif end_x <= start_x && end_y > start_y
      row -= 1
      column += 1
      until row == end_x
        return false unless @game_board[row][column] == nil
        row -= 1
        column += 1
      end
    end
    true
  end

  def locate_king(colour)
    king = all_pieces_on_board.select do |piece|
      piece.class == King && piece.colour == colour
    end[0] #return the first (only) value in the array
  end

  #given king pos and colour, find all enemy pieces on board
  #then select those that have a valid_move to attack the king
  def pieces_can_kill_king(king_pos, king_colour)
    enemy_pieces(king_colour).select do |piece|
      valid_move?(piece.location[0], piece.location[1], king_pos[0], king_pos[1])
    end
  end

  def enemy_pieces(king_colour)
    all_pieces_on_board.select { |piece| piece.colour != king_colour }
  end

  def check?(king_pos, king_colour)
    pieces_can_kill_king(king_pos, king_colour).empty? ? false : true
  end

  def check_mate?(king_colour)
    #find king piece
    king = locate_king(king_colour)
    return false if !check?(king.location, king_colour)

    return false if can_king_escape?(king, king_colour)

    attacking_pieces = pieces_can_kill_king(king.location, king_colour)
    if attacking_pieces.length == 1
      return false if can_attackers_be_captured?(attacking_pieces[0], king_colour)
      if attacking_pieces[0].class == Rook || attacking_pieces[0].class == Bishop || attacking_pieces[0].class == Queen
        return false if can_attack_be_blocked?(king.location, king_colour)
      end
    end

    true
  end

  #find king's valid moves, get the ones that lead to no enemy piece being
  #able to attack the king. if there arent any, return false.
  def can_king_escape?(king, king_colour)
    king_valid_moves = king.moves.select { |move|
      valid_move?(king.location[0],king.location[1], move[0], move[1])
    }

    escaping_moves = king_valid_moves.select { |move|
      pieces_can_kill_king(move, king_colour).empty?
    }

    escaping_moves.empty? ? false : true
  end

  def friendly_pieces(king_colour)
    all_pieces_on_board.select { |piece| piece.colour == king_colour }
  end

  def all_valid_moves(location, moves)
    moves.select { |move| valid_move?(location[0], location[1], move[0], move[1]) }
  end

  def can_attack_be_blocked?(king_pos, king_colour)
    friendlies = friendly_pieces(king_colour)
    #cycle through each friendly piece's moves and see if any move would lead
    #to king being out of check
    friendlies.each do |friendly|
      #copy the game_board before you make a test move
      current_board = Marshal.load(Marshal.dump(@game_board))
      valid_moves = all_valid_moves(friendly.location, friendly.moves)
      valid_moves.each do |move|
        @game_board[friendly.location[0]][friendly.location[1]] == nil
        @game_board[move[0]][move[1]] = friendly.class.new(move, king_colour)
        if check?(king_pos, king_colour) == false
          @game_board = current_board # reset game_board to it's state before the test moves
          return true
        else
          @game_board = current_board # reset game_board to it's state before the test moves
        end
      end
    end
    false
  end

  def can_attackers_be_captured?(attacker, king_colour)
    friendlies = all_pieces_on_board.select {|piece| piece.colour == king_colour}
    friendlies.any? do |piece|
      return false if piece.class == King
      valid_moves = piece.moves.select { |move|
        valid_move?(piece.location[0], piece.location[1], move[0], move[1])
      }
      valid_moves.include? (attacker.location)
    end
  end

  def all_pieces_on_board
    pieces = @game_board.map { |row|
      row.select { |square| square != nil  }
     }
    pieces = pieces.flatten #place all pieces in a one dimensional array
  end



  #go through each row and select square that != nil


  #returns true if sq is empty
  def empty_sq?(location)
    x = location[0]
    y = location[1]
    return true if @game_board[x][y] == nil
  end
  #returns true if enemy piece is at a sq.
  def enemy_at_sq?(colour, location)
    x = location[0]
    y = location[1]
    return false if @game_board[x][y] == nil
    return true if @game_board[x][y].colour != colour
  end

  def valid_pawn_move?(pawn, target_sq, end_y, start_y)
    #if it's in the same column, can only move two spaces if thats the pawn's
    #first move. the pawn can only move straight if target_sq is empty
    if end_y == start_y
      if (target_sq[0] - pawn.location[0]).abs == 2
        return false if pawn.already_moved == true
      end
      empty_sq?(target_sq)
    else # pawn does not move straight, needs to be enemy piece diagonally in front
      if enemy_at_sq?(pawn.colour, target_sq)
        return true
      else
        valid_enpassant_move?(pawn.colour, pawn.location[0], end_y)
      end
    end
  end

  #selects all enemy pawns on board and sets the instance variable
  #allow_for_enpassant to false.
  def turn_off_enpassant(colour)
    colour == "white" ? enemy_pawn_colour = "black" : enemy_pawn_colour = "white"
    enemy_pawns = all_pieces_on_board.select { |piece|
      piece.class == Pawn &&  piece.colour == enemy_pawn_colour
    }
    enemy_pawns.each { |pawn| pawn.allow_for_enpassant = false }
  end

  def pawn_specials(moved_piece, start_x, end_y)
    if enpassant_possible?(moved_piece, start_x)
      moved_piece.allow_for_enpassant = true
    end

    if valid_enpassant_move?(moved_piece.colour, start_x, end_y)
      #'kill' the captured piece, it will lie on the starting row but the ending column
      #of the enpassant-moving pawn.
      @game_board[start_x][end_y] = nil
    end

    if promotion?(moved_piece)
      moved_piece.promotion_allowed = true
    end

    moved_piece.already_moved = true
  end

  #captured pawn must move only two squares. The pawn must be captured immediately
  #if not, enpassant is invalid. you arent required to make enpassant move.
  def enpassant_possible?(pawn, start_x)
    #it has to be just after a 2 step move was made my a pawn
    return false if pawn.already_moved == true || (pawn.location[0] - start_x).abs != 2

    #check squares left and right of the potentially captured pawn
    [pawn.location[1] - 1, pawn.location[1] + 1].any? { |y|
      return false unless y.between?(0,7) # make sure it's on the board
      potential_attacker = @game_board[pawn.location[0]][y]
      potential_attacker.class == Pawn && potential_attacker.colour != pawn.colour
    }
  end

  def promotion?(pawn)
    #pawn cant move backwards so no need to check for colour
    return true if pawn.location[0] == 0 || pawn.location[0] == 7
  end

  def valid_enpassant_move?(colour, start_x, end_y)
    potential_pawn = @game_board[start_x][end_y]
    potential_pawn.class == Pawn && potential_pawn.colour != colour && potential_pawn.allow_for_enpassant == true
  end

end
