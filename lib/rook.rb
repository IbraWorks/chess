require_relative "piece.rb"
include Moves
class Rook < Piece
  attr_accessor :moves
  attr_reader :icon
  def initialize(location, colour)
    super
    @moves = get_poss_moves(location)
    @colour == "white" ? @icon = "U+2656" : @icon = "U+265C"
  end

  #rook moves straight vertically or horizontally, how many times it wants
  def get_poss_moves(location)
    x = location[0] #x is row
    y = location[1] #y is column
    move_list = [] #quarter circle forward punch

    move_list << vertical_moves(x,y)
    move_list << horizontal_moves(x,y)

    #make sure move is not off the board
    possible_moves = move_list.select { |e|
      (e[0] >= 0) && (e[0] <= 7) && (e[1] >= 0) && (e[1] <= 7)
    }
  end

end
