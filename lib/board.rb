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
    clear
    display_top_border
    display_rows
    display_bottom_border
    display_x_axis
  end

  def clear
    system 'clear'
    system 'cls'
  end

  def display_top_border
    puts '   ┌────┬────┬────┬────┬────┬────┬────┬────┐'
  end

  def display_rows
    (1..7).each do |row_number|
      display_row(row_number)
      display_separator
    end
    display_row(8)
  end

  def display_row(number)
    square = number.even? ? 0 : 1
    print "#{number-1}  "
    @game_board[number-1].each do |position|
      if position.nil?
        print square.even? ? '│    ' : "│#{'    '}"
      else
        print square.even? ? "│ #{position.icon}  " : "│#{" #{position.icon}  "}"
      end
      square += 1
    end
    puts '│'
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

  def display_separator
    puts '   ├────┼────┼────┼────┼────┼────┼────┼────┤'
  end

  def display_bottom_border
    puts '   └────┴────┴────┴────┴────┴────┴────┴────┘'
  end

  def display_x_axis
    puts "     0    1    2    3    4    5    6    7  \n\n"
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

    unless piece.class == Knight || piece.class == King
      return no_pieces_in_between?(start_x, start_y, end_x, end_y)
    end

    true
  end

  def no_pieces_in_between?(from_row, from_column, to_row, to_column)
    if from_row == to_row
      column = from_column < to_column ? from_column : to_column
      ending_column = column == from_column ? to_column : from_column
      column += 1
      until column == ending_column
        return false unless @game_board[from_row][column] == nil
        column += 1
      end
      true
    elsif from_column == to_column
      row = from_row < to_row ? from_row : to_row
      ending_row = row == from_row ? to_row : from_row
      row += 1
      until row == ending_row
        return false unless @game_board[row][from_column] == nil
        row += 1
      end
      true
    else
      no_pieces_in_between_diagonal?(from_row, from_column, to_row, to_column)
    end
  end

  # Given two points on the board that form a diagonal, returns true
  # if there are no pieces in between and false otherwise
  def no_pieces_in_between_diagonal?(from_row, from_column, to_row, to_column)
    row = from_row
    column = from_column
    if to_row > from_row && to_column > from_column
      row += 1
      column += 1
      until row == to_row
        return false unless @game_board[row][column] == nil
        row += 1
        column += 1
      end
    elsif to_row > from_row && to_column <= from_column
      row += 1
      column -= 1
      until row == to_row
        return false unless @game_board[row][column] == nil
        row += 1
        column -= 1
      end
    elsif to_row <= from_row && to_column <= from_column
      row -= 1
      column -= 1
      until row == to_row
        return false unless @game_board[row][column] == nil
        row -= 1
        column -= 1
      end
    elsif to_row <= from_row && to_column > from_column
      row -= 1
      column += 1
      until row == to_row
        return false unless @game_board[row][column] == nil
        row -= 1
        column += 1
      end
    end
    true
  end

  def all_valid_moves(location, moves)
    moves.select { |move| valid_move?(location[0], location[1], move[0], move[1]) }
  end

  def all_pieces_on_board
    pieces = @game_board.map { |row|
      row.select { |square| square != nil  }
     }.flatten #place all pieces in a one dimensional array
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

  def friendly_pieces(king_colour)
    all_pieces_on_board.select { |piece| piece.colour == king_colour }
  end

  def check?(king_pos, king_colour)
    !pieces_can_kill_king(king_pos, king_colour).empty?
  end

  def check_mate?(king_colour)
    #find king piece
    king = locate_king(king_colour)
    #puts "check: #{check?(king.location, king_colour)}"
    return false unless check?(king.location, king.colour)

    friendlies = friendly_pieces(king.colour)
    friendlies.all? { |friendly|
      all_valid_moves(friendly.location, friendly.moves).all? { |move|
        still_in_check_after_move?(friendly, move, friendly.colour)
      }
    }
  end

  def still_in_check_after_move?(piece, move, colour)
    current_board = Marshal.load(Marshal.dump(@game_board))
    @game_board[piece.location[0]][piece.location[1]] = nil
    @game_board[move[0]][move[1]] = piece.class.new(move, colour)

    still_check = check?(move, colour)
    @game_board = current_board
    puts "\npiece: #{piece.class}; loc: #{piece.location}; col: #{piece.colour}; move: #{move}; stillcheck: #{still_check}"
    still_check
  end

  def can_player_avoid_stalemate?(colour)
    potential_moves = []
    friendlies = friendly_pieces(colour)

    friendlies.any? do |friendly|
      valid_moves = all_valid_moves(friendly.location, friendly.moves)
      valid_moves.any? do |move|
        !still_in_check_after_move?(friendly, move, friendly.colour)
      end
    end

  end

  #returns true if sq is empty
  def empty_sq?(location)
    return @game_board[location[0]][location[1]] == nil
  end
  #returns true if enemy piece is at a sq.
  def enemy_at_sq?(colour, location)
    return false if @game_board[location[0]][location[1]] == nil
    @game_board[location[0]][location[1]].colour != colour
  end

  def valid_pawn_move?(pawn, target_sq, end_y, start_y)
    #if it's in the same column, can only move two spaces if thats the pawn's
    #first move. the pawn can only move straight if target_sq is empty
    if end_y == start_y
      if (target_sq[0] - pawn.location[0]).abs == 2
        return false if pawn.already_moved == true
      end
      empty_sq?(target_sq)
    else # if pawn not moving straight, needs to hit enemy piece unless its en_passant
      if enemy_at_sq?(pawn.colour, target_sq)
         true
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
    pawn.location[0] == 0 || pawn.location[0] == 7
  end

  def valid_enpassant_move?(colour, start_x, end_y)
    potential_pawn = @game_board[start_x][end_y]
    potential_pawn.class == Pawn && potential_pawn.colour != colour && potential_pawn.allow_for_enpassant == true
  end

end
