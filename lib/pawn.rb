require_relative "piece.rb"
include Moves
class Pawn < Piece
  attr_accessor :moves, :already_moved, :allow_for_enpassant, :promotion_allowed
  attr_reader :icon

  def initialize(location, colour)
    super
    @moves = get_poss_moves(location)
    @colour == "white" ? @icon = "U+2659" : @icon = "U+265F"
    @already_moved = false
    @allow_for_enpassant = false
    @promotion_allowed = false
  end

  #array with all moves pawn can make on empty board
  def get_poss_moves(location)
    x = location[0] #x is row
    y = location[1] #y is column

    move_list = [] #quarter circle forward punch

    if @colour == "white"
      move_list = white_pawn_moves(x,y)
    else
      move_list = black_pawn_moves(x,y)
    end

    possible_moves = move_list.select { |e|
      (e[0] >= 0) && (e[0] <= 7) && (e[1] >= 0) && (e[1] <= 7)
    }
    possible_moves
  end

  private

  def white_pawn_moves(x,y)
    move_list = []
    move_list << [x + 1, y + 0] #normal move when pawn just moves by one upwards
    move_list << [x + 2, y + 0] unless @already_moved == true #pawn can move two places if it's yet to move
    move_list << [x + 1, y + 1] # attacking move
    move_list << [x + 1, y - 1] # attacking move
    move_list
  end

  def black_pawn_moves(x,y) # the same as white but in opposite direction
    move_list = []
    move_list << [x - 1, y + 0]
    move_list << [x - 2, y + 0] unless @already_moved == true
    move_list << [x - 1, y + 1]
    move_list << [x - 1, y - 1]
    move_list
  end

end
