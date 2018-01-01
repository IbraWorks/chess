
class Board
attr_reader :game_board

  def initialize
    @game_board = Array.new(8) {Array.new(8, " ") }
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
  def move_piece (start_x, start_y, end_x, end_y)
    piece = @game_board[start_x][start_y]
    target_location = [end_x, end_y]
    @game_board[end_x][end_y] = piece.class.new(target_location, piece.colour)
    @game_board[start_x][start_y] = nil
  end

  #check if piece exists on starting sq.
  #check if piece can move to target sq.
  #check if target sq is empty or has enemy piece (need to accommodate king later)
  #check if pieces are in between
  #check for pawn difficulties
  def valid_move?(start_x, start_y, end_x, end_y)
    piece = @game_board[start_x][start_y]
    return false if piece == nil

    target_location = [end_x, end_y]
    return false if !piece.moves.include?(target_location)

    return pawn_validity?() if piece.class == Pawn
    return false unless empty_square?(target_location) || enemy_at_square(piece.colour, target_location)

  end

  def pawn_validity?()

  end
  def empty_square?(location)
    x = location[0]
    y = location[1]
    return true if @game_board[x][y] == nil
  end

  def enemy_at_square?(colour, location)

  end

end


=begin
class Board
  @rook_white = Rook.new(white)

  def legal_move?
      return false if !@rook_white.moveset(rook_location).include?(move)
      return false if move_blocked?(start, target)
      return false if target_square_contains_own_colour?(target)
  end

  def move_blocked?(start, target)
      # iterates over squares between start and target (NOT including target)
      # return true if any of those squares don't contain a blank space
  end

  def target_square_contains_own_colour?(target)
      # if target square contains enemy colour: return false
      # if target square contains own colour: return true
  end
end

play turn:
  1) ask for coordinates of starting and ending sq
  2) validate it:
          - check that the starting and ending sq exist
          - check the starting sq isnt empty
          - check that the starting sq is same colour as player
          - check the startingsq.class.moveset to see if the user-entered-move is contained in the moveset
          - if !startingsq.class == Knight
                  -check if the move is blocked (piece between start and target not including target)
          - is there a piec on the target sq?
               - Return illegal if it is own colour?
          - NB: as an extra: check king's condition
  3) call make_a_move method
  4) call visualise board
  5) identify if check-mate etc etc
  6) check for draws
  7)switch current player


def make_a_move (staring sq, ending sq)
  #assuming move is valid
  #go to end, instantiate same object with same colour and ending coord
  #take what object is on the starting sq, copy the class and colour, deletes it
end

def visualise_board
  #iterate through the gameboard array and puts
  @game_board[e.icon][e.icon]
end

class Board
  # Bishop, what are your possible moves from sq 7,7.
  # board needs to work out from the list of possible moves, which ones are valid
  # getting route from starting sq and ending sq, and then checking if any value in that root is !equal " "
  @gameboard.starting_square
end

=end
