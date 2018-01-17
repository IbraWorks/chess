require_relative "piece.rb"
class Knight < Piece
  attr_accessor :moves
  attr_reader :icon
  def initialize(location, colour)
    super
    @moves = get_poss_moves
    @colour == "white" ? @icon = "♞" : @icon = "♘"
  end

  def get_poss_moves
    x = @location[0] #x is row
    y = @location[1] #y is column
    #knight goes two steps forward, then one step sideways(either direction)
    move_list = [
                  [x + 2, y - 1],
                  [x + 2, y + 1],
                  [x - 2, y - 1],
                  [x - 2, y + 1],
                  #quarter circle forward punch
                  [x - 1, y + 2],
                  [x - 1, y - 2],
                  [x + 1, y + 2],
                  [x + 1, y - 2]
                ]

    #make sure move is not out of bounds
    possible_moves = move_list.select { |e|
      (e[0] >= 0) && (e[0] <= 7) && (e[1] >= 0) && (e[1] <= 7)
    }
    possible_moves
  end

end
