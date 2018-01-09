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
    target_location = [end_x, end_y]
    @game_board[end_x][end_y] = piece.class.new(target_location, piece.colour)
    @game_board[start_x][start_y] = nil

    moved_piece = @game_board[end_x][end_y]
    if moved_piece.class == Pawn
      pawn_specials(moved_piece, start_x, end_y)
    end

    turn_off_enpassant(piece.colour) #once a move has been made, disallow enpassant on enemy pawns.
  end

  #check if piece exists on starting sq. check if piece can move to target sq.
  #check if target sq is empty or has enemy piece (need to accommodate king later)
  #check if pieces are in between. check for pawn difficulties
  def valid_move?(start_x, start_y, end_x, end_y)
    return false if start_x > 7 || start_x < 0
    return false if start_y > 7 || start_y < 0
    return false if end_x > 7 || end_x < 0
    return false if end_y > 7 || end_y < 0
    piece = @game_board[start_x][start_y]
    return false if piece == nil

    target_sq = [end_x, end_y]
    return false unless piece.moves.include? target_sq

    return valid_pawn_move?(piece, target_sq, end_y, start_y) if piece.class == Pawn

    return false unless empty_sq?(target_sq) || enemy_at_sq?(piece.colour, target_sq)

    #need to check for spaces in between

    #if it passes all rigirous checks, return true (not nil)
    return true
  end

  #go through each row and select square that != nil
  def all_pieces_on_board
    pieces = @game_board.map { |row|
      row.select { |square| square != nil  }
     }
    pieces = pieces.flatten #place all pieces in a one dimensional array
  end

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
      if enemy_at_square?(pawn.colour, target_sq)
        return true
      else
        valid_enpassant_move?(pawn.colour, pawn.target_sq[0], end_y)
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
    if pawn.already_moved == true || (pawn.location[0] - start_x).abs != 2
      return false
    end
    #check squares left and right of the potentially captured pawn
    [pawn.location[1] + 1, pawn.location[1] - 1].any? { |y|
      return false unless y.between?(0,7) # make sure it's on the board
      potential_attacker = @game_board[pawn.location[0]][y]
      if potential_attacker.class == Pawn && potential_attacker.colour != pawn.colour
        return true
      end
    }
  end

  def promotion?(pawn)
    #pawn cant move backwards so no need to check for colour
    return true if pawn.location[0] == 0 || pawn.location[0] == 7
  end

  def valid_enpassant_move?(colour, start_x, end_y)
    potential_pawn = @game_board[start_x][end_y]
    return true if potential_pawn.colour != colour && potential_pawn.class == Pawn && potential_pawn.allow_for_enpassant == true
  end

end
