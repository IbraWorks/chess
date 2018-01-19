require_relative "piece.rb"

class King < Piece
  attr_accessor :moves
  attr_reader :icon, :already_moved

  def initialize(location, colour, already_moved = true)
    super(location, colour)
    @colour == "white" ? @icon = "♚" : @icon = "♔"
    @already_moved = already_moved
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

    if @already_moved == false 
      move_list << [x, y + 2]
      move_list << [x, y - 2]
    end
    #make sure move is on the board
    possible_moves = move_list.select { |e|
      (e[0] >= 0) && (e[0] <= 7) && (e[1] >= 0) && (e[1] <= 7)
    }
  end

end
