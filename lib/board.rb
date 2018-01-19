class Board
  #x is row, y is column. I know that is a bit confusing. sorry
attr_reader :game_board

  def initialize
    @game_board = Array.new(8) {Array.new(8, " ") }

    @game_board[0][0] = Rook.new([0,0], "black", false)
    @game_board[0][1] = Knight.new([0,1], "black")
    @game_board[0][2] = Bishop.new([0,2], "black")
    @game_board[0][3] = Queen.new([0,3], "black")
    @game_board[0][4] = King.new([0,4], "black", false)
    @game_board[0][5] = Bishop.new([0,5], "black")
    @game_board[0][6] = Knight.new([0,6], "black")
    @game_board[0][7] = Rook.new([0,7], "black", false)

    @game_board[7][0] = Rook.new([7,0], "white", false)
    @game_board[7][1] = Knight.new([7,1], "white")
    @game_board[7][2] = Bishop.new([7,2], "white")
    @game_board[7][3] = Queen.new([7,3], "white")
    @game_board[7][4] = King.new([7,4], "white", false)
    @game_board[7][5] = Bishop.new([7,5], "white")
    @game_board[7][6] = Knight.new([7,6], "white")
    @game_board[7][7] = Rook.new([7,7], "white", false)

    0.upto(7) {|y| @game_board[6][y] = Pawn.new([6,y], "white")}
    0.upto(7) {|y| @game_board[1][y] = Pawn.new([1,y], "black")}

    0.upto(7) {|y| @game_board[5][y] = nil}
    0.upto(7) {|y| @game_board[4][y] = nil}
    0.upto(7) {|y| @game_board[3][y] = nil}
    0.upto(7) {|y| @game_board[2][y] = nil}
  end


  def display_board
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
    puts "     a    b    c    d    e    f    g    h  \n\n"
  end


  #take the starting and ending coord, and instantiate a new object on the
  #ending coord using the instance variables from the starting one.
  #then make the starting coord == nil
  def move_piece(start_x, start_y, end_x, end_y)
    if castling_move?(start_x, start_y, end_x, end_y)
      move_castling_rook([start_x, start_y], [end_x, end_y])
    end
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
    start_sq = [start_x, start_y]
    target_sq = [end_x, end_y]
    return false unless piece.moves.include?(target_sq)

    return valid_pawn_move?(piece, target_sq, end_y, start_y) if piece.class == Pawn

    return false unless empty_sq?(target_sq) || enemy_at_sq?(piece.colour, target_sq)

    unless piece.class == Knight || piece.class == King
      return no_pieces_in_between?(start_x, start_y, end_x, end_y)
    end

    if castling_move?(start_x, start_y, end_x, end_y) then return false if !valid_castling_move?(piece, target_sq) end

    true
  end

  def valid_castling_move?(piece, target_sq)
    rook = return_castling_rook(piece.location, target_sq)
    return false if rook.class != Rook || rook.already_moved
    return false if !no_pieces_in_between?(rook.location[0], rook.location[1], piece.location[0], piece.location[1])
    return false if piece_under_attack?(piece.location, piece.colour)
    return false if castling_route_in_check?(rook.location, piece.location, piece.colour)
    true
  end

  def castling_route_in_check?(rook_loc, king_loc, king_colour)
    column = rook_loc[1] < king_loc[1] ? rook_loc[1] : king_loc[1]
    ending_column = column == rook_loc[1] ? king_loc[1] : rook_loc[1]
    column += 1
    until column == ending_column
      return true if piece_under_attack?([rook_loc[0],column], king_colour)
      column += 1
    end
    false
  end

  def castling_move?(start_x, start_y, end_x, end_y)
    starting_piece = @game_board[start_x][start_y]
    return false if starting_piece.class != King
    #has to be on the same row, column seperated by two
    (start_x == end_x) && (end_y - start_y).abs == 2
  end

  def move_castling_rook(king_start, king_end)
    rook = return_castling_rook(king_start, king_end)
    puts "\nrook piece: #{rook}; king_start: #{king_start}; king_end: #{king_end}"
    kingside = (king_end[1] == king_start[1] + 2) ? true : false
    rook_target = kingside ? [king_start[0], king_start[1] + 1] : [king_start[0], king_start[1] - 1]
    move_piece(rook.location[0], rook.location[1], rook_target[0], rook_target[1])
  end

  def return_castling_rook(start_sq, target_sq)
    kingside = (target_sq[1] == start_sq[1] + 2) ? true : false
    rook_loc = (kingside ? [target_sq[0], target_sq[1] + 1] : [target_sq[0], target_sq[1] - 2] )
    puts "\n rook_loc: #{rook_loc}"
    return @game_board[rook_loc[0]][rook_loc[1]]
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

  def piece_under_attack?(location, colour)
    enemy_pieces(colour).each { |att_piece|
      return true if valid_move?(att_piece.location[0], att_piece.location[1], location[0], location[1])
    }
    false
  end


  def check?(king_pos, king_colour)
    piece_under_attack?(king_pos, king_colour)
  end

  def other_colour(colour)
    colour == "white" ? "black" : "white"
  end

  def check_own_king?(start_sq, target_sq, king_colour)
    piece = @game_board[start_sq[0]][start_sq[1]]
    target_piece = @game_board[target_sq[0]][target_sq[1]]
    move_piece(start_sq[0],start_sq[1],target_sq[0],target_sq[1])
    king = locate_king(piece.colour)
    is_king_checked = piece_under_attack?(king.location, king_colour)
    undo_move(start_sq, target_sq, piece, target_piece)
    is_king_checked
  end

  def stalemate?(king_colour)
    king = locate_king(king_colour)
    return false if check?(king.location, king_colour)

    friendlies = friendly_pieces(king_colour)
    friendlies.all? { |friendly|
      all_valid_moves(friendly.location, friendly.moves).all? { |move|
        check_own_king?(friendly.location, move, king_colour)
      }
    }
  end

  def check_mate?(king_colour)
    king = locate_king(king_colour)

    return false unless check?(king.location, king_colour)

    friendlies = friendly_pieces(king_colour)
    friendlies.all? { |friendly|
      all_valid_moves(friendly.location, friendly.moves).all? { |move|
        check_own_king?(friendly.location, move, king_colour)
      }
    }
  end

  def undo_move(start_location, target_location, start_piece, target_piece)
    @game_board[target_location[0]][target_location[1]] = nil # this line might not be necessary
    create_piece(start_piece, start_location)
    create_piece(target_piece, target_location)
  end

  def create_piece(piece, location)
    if piece == nil
      @game_board[location[0]][location[1]] = nil
    else
      @game_board[location[0]][location[1]] = piece.class.new(location, piece.colour)
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

  def promotion?(colour)
    row = colour == "white" ? 0 : 7
    @game_board[row].any? { |e| e.class == Pawn  }
  end

  def promote(new_class, colour)
    pawn_location = location_of_promoting_pawn(colour)
    upgrade = new_class.new(pawn_location, colour)
    create_piece(upgrade, pawn_location)
  end

  def location_of_promoting_pawn(colour)
    row = colour == "white" ? 0 : 7
    col = @game_board[row].index{|e| e.class == Pawn }
    [row,col]
  end

  def valid_enpassant_move?(colour, start_x, end_y)
    potential_pawn = @game_board[start_x][end_y]
    potential_pawn.class == Pawn && potential_pawn.colour != colour && potential_pawn.allow_for_enpassant == true
  end

end
