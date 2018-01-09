require_relative "piece.rb"

class Bishop < Piece
  include Moves
  attr_accessor :moves
  attr_reader :icon
  def initialize(location, colour)
    super
    @moves = get_poss_moves
    @colour == "white" ? @icon = "\U+2657" : @icon = "\U+265D"
  end

  #bishop moves diagonally, how many times it wants
  def get_poss_moves
    x = @location[0] #x is row
    y = @location[1] #y is column
    move_list = [] #quarter circle forward punch

    left_diags = diagonally_left_moves(x,y)
    left_diags.each { |move| move_list << move }

    right_diags = diagonally_right_moves(x,y)
    right_diags.each { |move| move_list << move  }

    possible_moves = move_list.select { |e|
      (e[0] >= 0) && (e[0] <= 7) && (e[1] >= 0) && (e[1] <= 7)
    }
    possible_moves
  end
end
