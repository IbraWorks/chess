require_relative "piece.rb"

class King < Piece
  attr_accessor :moves
  attr_reader :icon

  def initialize(location, colour)
    super
    @colour == "white" ? @icon = "♚" : @icon = "♔"
    @moves = get_poss_moves
  end

  def get_poss_moves
    x = @location[0]
    y = @location[1]

    move_list = [
                  [x + 1, y + 0],
                  [x - 1, y + 0],

                  [x + 0, y + 1],
                  [x + 0, y - 1],

                  [x + 1, y + 1],
                  [x + 1, y - 1],

                  [x - 1, y + 1],
                  [x - 1, y - 1]
                ]
    #make sure move is on the board
    possible_moves = move_list.select { |e|
      (e[0] >= 0) && (e[0] <= 7) && (e[1] >= 0) && (e[1] <= 7)
    }
  end

end
