module Moves

  def diagonally_left_moves(x,y)
    move_list = []
    1.upto(7) { |e| move_list << [x + e, y - e]  } # go down-left
    1.upto(7) { |e| move_list << [x - e, y - e]  } # go up-left
    return move_list
  end

  def diagonally_right_moves(x,y)
    move_list = []
    1.upto(7) { |e| move_list << [x + e, y + e]  } # go down-right
    1.upto(7) { |e| move_list << [x - e, y + e]  } # go up-right
    return move_list
  end

  def horizontal_moves(x,y)
    move_list = []
    1.upto(7) { |e| move_list << [x + 0, y + e]  } #going right
    1.upto(7) { |e| move_list << [x + 0, y - e]  } #going left
    return move_list
  end

  def vertical_moves(x,y)
    move_list = []
    1.upto(7) { |e| move_list << [x + e, y + 0]  } #going down
    1.upto(7) { |e| move_list << [x - e, y + 0]  } #going up (on a tuesday - i hate that song)
    return move_list
  end

end

class Piece
  attr_accessor :location
  attr_reader :colour

  def initialize(location, colour)
    @location = location
    @colour = colour
  end

end
