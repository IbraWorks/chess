require "board.rb"

describe Board do

  describe "#initialize" do
    let(:board) {Board.new}

    it "initializes a chess board array with all pieces in correct places" do
      expect(board.game_board.size).to eq(8)
      expect(board.game_board.all?{|row| row.size == 8}).to eq(true)
      expect(board.game_board[0][0].class).to eq(Rook)
      expect(board.game_board[0][1].class).to eq(Knight)
      expect(board.game_board[0][2].class).to eq(Bishop)
      expect(board.game_board[0][3].class).to eq(Queen)
      expect(board.game_board[0][4].class).to eq(King)
      expect(board.game_board[0][5].class).to eq(Bishop)
      expect(board.game_board[0][6].class).to eq(Knight)
      expect(board.game_board[0][7].class).to eq(Rook)
      expect(board.game_board[7][0].class).to eq(Rook)
      expect(board.game_board[7][1].class).to eq(Knight)
      expect(board.game_board[7][2].class).to eq(Bishop)
      expect(board.game_board[7][3].class).to eq(Queen)
      expect(board.game_board[7][4].class).to eq(King)
      expect(board.game_board[7][5].class).to eq(Bishop)
      expect(board.game_board[7][6].class).to eq(Knight)
      expect(board.game_board[7][7].class).to eq(Rook)
      expect(board.game_board[6].all? { |sq| sq.class == Pawn }).to eql(true)
      expect(board.game_board[1].all? { |sq| sq.class == Pawn }).to eql(true)
      expect(2.upto(5).all?{|row|
        board.game_board[row].all?{|sq| sq == nil}
      }).to eq(true)
    end
  end

  describe "#move_piece" do
    let(:board){Board.new}

    context "given black knight moves from [0,1] to [2,2]" do
      it "moves black knight from [0,1] to [2,2]" do
        board.move_piece(0,1,2,2)
        expect(board.game_board[0][1]).to eql(nil)
        expect(board.game_board[2][2].class).to eql(Knight)
        expect(board.game_board[2][2].colour).to eql("black")
      end
    end

    context "given white rook moving from [7,0] tp [4,0]" do
      it "moves rook to [4,0]" do
        board.move_piece(7,0,4,0)
        expect(board.game_board[7][0]).to eql(nil)
        expect(board.game_board[4][0].class).to eql(Rook)
        expect(board.game_board[4][0].colour).to eql("white")
      end
    end

    context "given black rook moving from [0,0] to [3,0]" do
      it "moves rook piece from [0,0] to [3,0]" do
        board.move_piece(0,0,3,0)
        expect(board.game_board[0][0]).to eql(nil)
        expect(board.game_board[3][0].class).to eql(Rook)
        expect(board.game_board[3][0].colour).to eql("black")
      end
    end

    context "given white rook moving from [7,0] to [5,0]" do
      it "moves white rook from [7,0] to [5,0]" do
        board.move_piece(7,0,5,0)
        expect(board.game_board[7][0]).to eql(nil)
        expect(board.game_board[5][0].class).to eql(Rook)
        expect(board.game_board[5][0].colour).to eql("white")
      end
    end
    context "given white queen moves to [1,3] where black pawn is located" do
      it "moves queen to [1,3] and captures black pawn" do
        board.move_piece(7,3,1,3)
        expect(board.game_board[7][3]).to eql(nil)
        expect(board.game_board[1][3].class).to eql(Queen)
        expect(board.game_board[1][3].colour).to eql("white")
      end
    end

    context "given black pawn moves from location [1,7] to [3,7]" do
      it "moves black pawn to [3,7]" do
        board.move_piece(1,7,3,7)
        expect(board.game_board[1][7]).to eql(nil)
        expect(board.game_board[3][7].class).to eql(Pawn)
        expect(board.game_board[3][7].colour).to eql("black")
      end
    end

    context "given black pawn moves from [1,2] to [3,2] with white pawn at [3,3]" do
      it "sets @allow_for_enpassant to be true on the black pawn" do
        expect(board.game_board[1][2].allow_for_enpassant).to eql(false)
        board.move_piece(6,3,4,3)
        board.move_piece(4,3,3,3)
        board.move_piece(1,2,3,2)
        expect(board.game_board[3][2].allow_for_enpassant).to eql(true)
      end
    end

    context "given black rook moves from [0,0] to [7,0] where white rook is located" do
      it "moves black rook to [7,0] and captures white rook" do
        board.move_piece(0,0,7,0)
        expect(board.game_board[0][0]).to eql(nil)
        expect(board.game_board[7][0].class).to eql(Rook)
        expect(board.game_board[7][0].colour).to eql("black")
      end
    end

#    context "given white player castles kingside" do
#      it "returns true" do
#        board.game_board[7][5] = nil
#        board.game_board[7][6] = nil
#        board.move_piece(7,4,7,6)
#        expect(board.game_board[7][6].class).to eql(King)
#        expect(board.game_board[7][6].colour).to eql("white")
#      end
#    end

    context "given white pawn moves from [6,7] to [5,7] then [4,7] with black pawn at [4,6]" do
      it "does not set @allow_for_enpassant to true for the white pawn" do
        expect(board.game_board[6][7].allow_for_enpassant).to eql(false)
        board.move_piece(6,7,5,7)
        board.move_piece(5,7,4,7)
        board.move_piece(1,6,3,6)
        board.move_piece(3,6,4,6)
        expect(board.game_board[4][7].allow_for_enpassant).to eql(false)
      end
    end

    context "white pawn moves from [6,7] to [4,7] with black pawn at [4,6] and black taking another turn" do
      it "does not set @allow_for_enpassant to true for the white pawn after blacks turn" do
        expect(board.game_board[6][7].allow_for_enpassant).to eql(false)
        board.move_piece(1,6,3,6)
        board.move_piece(3,6,4,6)
        board.move_piece(6,7,4,7)
        expect(board.game_board[4][7].allow_for_enpassant).to eql(true)
        board.move_piece(1,0,3,0)
        expect(board.game_board[4][7].allow_for_enpassant).to eql(false)
      end
    end

    context "given white pawn at [3,1] exercising en_passant on a black pawn at [3,2] " do
      it "moves white pawn to [2,2] and captures black pawn" do
        board.move_piece(6,1,4,1)
        board.move_piece(4,1,3,1)
        board.move_piece(1,2,3,2)
        board.move_piece(3,1,2,2)
        expect(board.game_board[3][2]).to eql(nil)
        expect(board.game_board[2][2].class).to eql(Pawn)
        expect(board.game_board[2][2].colour).to eql("white")
      end
    end

  end

  describe "#piece_is_players_piece?" do
    let(:board){Board.new}
    context "given location of a player's piece" do
      it "returns true" do
        expect(board.piece_is_players_piece?([0,3], "black")).to eql(true)
      end
    end
  end

  describe "#valid_move?" do
    let(:board){Board.new}

    context "given an empty starting square" do
      it "returns false" do
        expect(board.valid_move?(4,3,4,4)).to be_falsey
      end
    end

    context "given same starting sq and target sq" do
      it "returns false" do
        expect(board.valid_move?(1,1,1,1)).to be_falsey
      end
    end

    context "given a starting sq that is off the board" do
      it "returns false" do
        expect(board.valid_move?(10,10,1,1)).to be_falsey
      end
    end

    context "given target sq that is off the board" do
      it "returns false" do
        expect(board.valid_move?(1,1,10,10)).to be_falsey
      end
    end

    context "given black pawn moves from [1,0] to [2,0]" do
      it "returns true" do
         expect(board.valid_move?(1,0,2,0)).to eql(true)
      end
    end

    context "given black pawn moving from [1,0] to [3,0]" do
      it "returns true" do
        expect(board.valid_move?(1,0,3,0)).to eql(true)
      end
    end

    context "given black pawn moving from [2,0] to [4,0] after it has moved already" do
      it "returns false" do
        board.move_piece(1,0,2,0)
        expect(board.valid_move?(2,0,4,0)).to eql(false)
      end
    end

    context "given black pawn moves from [1,3] to [2,4] on starting board" do
      it "returns false" do
        expect(board.valid_move?(1,3,2,4)).to eql(false)
      end
    end

    context "given white pawn moves from [6,5] to [5,4] to capture black pawn" do
      it "returns true" do
        board.game_board[5][4] = Pawn.new([5,4], "black")
        expect(board.valid_move?(6,5,5,4)).to eql(true)
      end
    end

    context "given white pawn moves from [6,0] to [4,0]" do
      it "returns true" do
        expect(board.valid_move?(6,0,4,0)).to eql(true)
      end
    end

    context "given black rook moves from [0,0] to [2,0] where there is a piece in between" do
      it "returns false" do
        expect(board.valid_move?(0,0,2,0)).to eql(false)
      end
    end
    context "given black rook moves from [0,0] to an empty [2,0]" do
      it "returns true" do
        board.game_board[1][0] = nil
        expect(board.valid_move?(0,0,2,0)).to eql(true)
      end
    end

    context "given white knight moves from [7,1] to [5,0]" do
      it "returns true" do
        expect(board.valid_move?(7,1,5,0)).to eql(true)
      end
    end

    context "given white knight moves from [7,1] to occupied [6,3] on starting board" do
      it "returns false" do
        expect(board.valid_move?(7,1,6,3)).to eql(false)
      end
    end

    context "given black bishop moves from [0,3] to [2,4] with piece in between" do
      it "returns false" do
        expect(board.valid_move?(0,3,2,4)).to eql(false)
      end
    end

    context "given black queen wants to attack king vertically with piece in between" do
      it "returns false" do
        board.move_piece(1,4,2,4) #move black pawn
        board.move_piece(0,3,2,5) #move queen next to it
        board.move_piece(2,5,3,4) #move queen in front of it so that its same row as white king
        expect(board.valid_move?(3,4,7,4)).to eql(false)
      end
    end

    context "given bishop moves from [0,5] to [2,7] with nothing in between" do
      it "returns true" do
        board.game_board[1][6] = nil
        expect(board.valid_move?(0,5,2,7)).to eql(true)
      end
    end

    context "white queen moves to a position occupied by white pawn" do
      it "returns false" do
        board.game_board[5][5] = Queen.new([5,5], "black")
        expect(board.valid_move?(5,5,1,5)).to eql(false)
      end
    end

    context "black king moves from [5,5] to [3,5] with no spaces in between" do
      it "returns false" do
        board.game_board[5][5] = King.new([5,5], "black")
        expect(board.valid_move?(5,5,3,5)).to eql(false)
      end
    end

    context "black king moves from [5,5] to [4,5]" do
      it "returns true" do
        board.game_board[5][5] = King.new([5,5], "black")
        expect(board.valid_move?(5,5,4,5)).to eql(true)
      end
    end

    context "black pawn at [4,6] taking white pawn [4,5] via enpassant to [5,5]" do
      it "returns true" do
        board.move_piece(1,6,3,6)
        board.move_piece(3,6,4,6)
        board.move_piece(6,5,4,5)
        expect(board.valid_move?(4,6,5,5)).to eql(true)
      end
    end

    context "given black pawn ([4,6] to [5,5] capturing white pawn at [4,5]) but before capturing via en passant plays another move" do
      it "returns false" do
        board.move_piece(1,6,3,6)
        board.move_piece(3,6,4,6)
        board.move_piece(6,5,4,5)
        board.move_piece(1,2,2,2)
        expect(board.valid_move?(4,6,5,5)).to eql(false)
      end
    end

    context "same move by black pawn ([4,6] to [5,5] capturing white pawn at [4,5]) but white pawn gets to [4,5] in two moves" do
      it "returns false" do
        board.move_piece(1,6,3,6)
        board.move_piece(3,6,4,6)
        board.move_piece(6,5,5,5)
        board.move_piece(5,5,4,5)
        expect(board.valid_move?(4,6,5,5)).to eql(false)
      end
    end

    context "given white pawn moves from [6,7] to [4,7] to capture a piece" do
      it "returns false" do
        board.game_board[4][7] = Queen.new([4,7], "black")
        expect(board.valid_move?(6,7,4,7)).to eql(false)
      end
    end

    context "after a few moves, white pawn tries to take first move [6,0][4,0] to capture enemy piece" do
      it "returns false" do
        board.move_piece(6,5,5,5)
        board.move_piece(1,4,3,4)
        board.move_piece(6,6,4,6)
        board.move_piece(0,3,4,7)
        expect(board.valid_move?(6,7,4,7)).to eql(false)
      end
    end

#    context "given user (white) castles kingside" do
#      it "returns true" do
#        board.game_board[7][5] = nil
#        board.game_board[7][6] = nil
#        expect(board.valid_move?(7,4,7,6)).to eql(true)
#      end
#    end

    context "practical castling test" do
      it "returns true" do
        board.move_piece(7,6,5,5)
        board.move_piece(1,0,2,0)
        board.move_piece(6,6,4,6)
        board.move_piece(2,0,3,0)
        board.move_piece(7,5,5,7)
        board.move_piece(3,0,4,0)

        expect(board.valid_move?(7,4,7,6)).to eql(true)
        board.move_piece(7,4,7,6)
        board.display_board
      end
    end

    context "practical castling test, given rook as already moved" do
      it "returns false" do
        board.move_piece(7,6,5,5)
        board.move_piece(1,0,2,0)
        board.move_piece(6,6,4,6)
        board.move_piece(2,0,3,0)
        board.move_piece(7,5,5,7)
        board.move_piece(3,0,4,0)
        board.move_piece(7,7,7,6)
        board.move_piece(7,6,7,7)
        expect(board.valid_move?(7,4,7,6)).to eql(false)
      #  board.move_piece(7,4,7,6)
      #  board.display_board
      end
    end


    context "practical castling test, given rook as already moved" do
      it "returns false" do
        board.move_piece(7,6,5,5)
        board.move_piece(1,0,2,0)
        board.move_piece(6,6,4,6)
        board.move_piece(2,0,3,0)
        board.move_piece(7,5,5,7)
        board.move_piece(3,0,4,0)
        board.move_piece(7,7,7,6)
        expect(board.valid_move?(7,4,7,6)).to eql(false)
        #board.move_piece(7,4,7,6)
        #board.display_board
      end
    end

  end

  describe "#check?" do
    let(:board) { Board.new }

    context "given a black king on a starting board" do
        it "returns false" do
          king_location = board.locate_king("black").location
          expect(board.check?(king_location, "black")).to eql(false)
      end
    end

    context "given a white king at [7,4] with blocked path white queen at [3,4]" do
      it "returns false" do
        board.move_piece(1,4,2,4) #move black pawn
        board.move_piece(0,3,2,5) #move queen next to it
        board.move_piece(2,5,3,4) #move queen in front of it so that its same row as white king
        expect(board.check?(board.game_board[7][4].location, "white")).to eql(false)
      end
    end

    context "given a white king at [7,4] with clear path black queen at [3,4]" do
      it "returns true" do
        board.game_board[6][4] = nil
        board.move_piece(1,4,2,4)
        board.move_piece(0,3,2,5)
        board.move_piece(2,5,3,4)
        king_location = board.locate_king("white").location
        expect(board.check?(king_location, "white")).to eql(true)
      end
    end

    context "given a black king at [0,4] with an unobstructed path to "\
        "white queen at [4,4]" do
      it "returns true" do
        board.game_board[1][4] = nil
        board.game_board[4][4] = Queen.new([4,4], "white")
        king_location = board.locate_king("black").location
        expect(board.check?(king_location, "black")).to eql(true)
      end
    end
    context "given a black king [0,4] with white queen at [4,4] with blocked path" do
      it "returns false" do
        board.game_board[4][4] = Queen.new([4,4], "white")
        king_location = board.locate_king("black").location
        expect(board.check?(king_location, "black")).to eql(false)
      end
    end

    context "given white king at [3,7] with black rook at [3,0] with clear path" do
      it "returns true" do
        board.game_board[7][4] = nil
        board.game_board[3][7] = King.new([3,7], "white")
        board.game_board[3][0] = Rook.new([3,0], "black")
        king_location = board.locate_king("white").location
        expect(board.check?(king_location, "white")).to eql(true)
      end
    end

    context "given black king at [5,6] with clear path for white pawns at [6,5] and [6,7]" do
      it "returns true" do
        board.game_board[0][4] = nil
        board.game_board[5][6] = King.new([5,6], "black")
        king_location = board.locate_king("black").location
        expect(board.check?(king_location, "black")).to eql(true)
      end
    end

    context "given black king at [3,4] with white knight at [5,3]" do
      it "returns true" do
        board.game_board[0][4] = nil
        board.game_board[3][4] = King.new([3,4], "black")
        board.game_board[5][3] = Knight.new([5,3], "white")
        king_location = board.locate_king("black").location
        expect(board.check?(king_location, "black")).to eql(true)
      end
    end

    context "given white king at [4,1] with black king at [4,2]" do
      it "returns true" do
        board.game_board[0][4] = nil
        board.game_board[7][4] = nil
        board.game_board[4][1] = King.new([4,1], "white")
        board.game_board[4][2] = King.new([4,2], "black")
        king_location = board.locate_king("white").location
        expect(board.check?(king_location, "white")).to eql(true)
      end
    end


  end

  describe "#check_own_king?" do
    let(:board){Board.new}
    context "given white king moves from [7,4] to [6,5] with no pawn at [6,5] and a queen at [3,5] " do
      it "returns true" do
        board.game_board[6][5] = nil
        board.game_board[3][5] = Queen.new([3,5], "black")
        expect(board.check_own_king?([7,4], [6,5], "white")).to eql(true)
      end
    end
  end


  describe "#can_player_avoid_stalemate?" do
    let(:board){Board.new}

    context "given player can not make a move that won't lead them into check" do
      it "returns true" do
        board.instance_variable_set(:@game_board, board.game_board.map do |row|
            row.map { |square| nil }
        end)

        board.game_board[7][5] = King.new([7,5], "black")
        board.game_board[6][5] = Bishop.new([6,5], "white")
        board.game_board[5][5] = Queen.new([5,5], "white")
        expect(board.stalemate?("black")).to eql(true)
      end
    end

    context "given black king at [0,0] with white rook at [1,1] and white king at [2,2]" do
      it "returns true" do
        board.instance_variable_set(:@game_board, board.game_board.map do |row|
            row.map { |square| nil }
        end)
        board.game_board[0][0] = King.new([0,0], "black")
        board.game_board[1][1] = Rook.new([1,1], "white")
        board.game_board[2][2] = King.new([2,2], "white")
        expect(board.stalemate?("black")).to eql(true)
      end
    end

    context "black king at [7,0], black bishop at [7,1], white rook at [7,7], white king at[5,1]" do
      it "returns false" do
        board.instance_variable_set(:@game_board, board.game_board.map do |row|
            row.map { |square| nil }
        end)
        board.game_board[7][0] = King.new([7,0], "black")
        board.game_board[7][1] = Bishop.new([7,1], "black")
        board.game_board[7][7] = Rook.new([7,7], "white")
        board.game_board[5][1] = King.new([5,1], "white")
        expect(board.stalemate?("white")).to eql(false)
      end
    end

    context "black king at [0,4], white king at [7,7] white queen at [7,0]" do
      it "returns true" do
        board.instance_variable_set(:@game_board, board.game_board.map do |row|
            row.map { |square| nil }
        end)
        board.game_board[0][4] = King.new([0,4], "black")
        board.game_board[7][7] = King.new([7,7], "white")
        board.game_board[7][0] = Queen.new([7,0], "white")
        expect(board.stalemate?("black")).to eql(false)
      end
    end


  end


  describe "#check_mate?" do

    let(:board){Board.new}

    context "given a black king on starting board" do
      it "returns false" do
        king_location = board.locate_king("black").location
        expect(board.check_mate?("black")).to eql(false)
      end
    end
    context "given black king at [4,7], white rook at [0,7] and white king at [4,5]" do
      it "returns true" do
        board.instance_variable_set(:@game_board, board.game_board.map do |row|
            row.map { |square| nil }
        end)
        board.game_board[4][7] = King.new([4,7], "black")
        board.game_board[0][7] = Rook.new([0,7], "white")
        board.game_board[4][5] = King.new([4,5], "white")
        expect(board.check_mate?("black")).to eql(true)
      end
    end

    context "given black king in check can move out of check" do
      it "returns false" do
        board.game_board[1][4] = nil #get rid of blocking pawn
        board.game_board[4][4] = Queen.new([4,4], "white") # attacking queen
        board.game_board[1][3] = nil #get rid of pawn so king can move out of check
        expect(board.check_mate?("black")).to eql(false)
      end
    end

    context "given fools mate (fastest checkmate) for black" do
      it "returns true" do
        board.move_piece(6,5,5,5)
        board.move_piece(1,4,3,4)
        board.move_piece(6,6,4,6)
        board.move_piece(0,3,4,7)
        expect(board.check_mate?("white")).to eql(true)
      end
    end

    context "given black king in check with a friendly piece that can block the attack" do
      it "returns false" do
        board.game_board[1][4] = nil
        board.game_board[4][4] = Rook.new([4,4], "white")
        board.game_board[2][3] = Bishop.new([2,3], "black") #piece that will block attack
        expect(board.check_mate?("black")).to eql(false)
      end
    end


    context "given white king at [7,7] checked and mated by black rooks at [7,0] and [6,0]" do
      it "returns true" do
        board.instance_variable_set(:@game_board, board.game_board.map do |row|
            row.map { |square| nil }
        end)
        board.game_board[7][7] = King.new([7,7], "white")
        board.game_board[7][1] = Rook.new([7,1], "black")
        board.game_board[6][0] = Rook.new([6,0], "black")

        expect(board.check_mate?("white")).to eql(true)
      end
    end

    context "the final test" do
      it "returns true" do
       board.instance_variable_set(:@game_board, board.game_board.map do |row|
             row.map { |square| nil }
       end)
       board.game_board[4][7] = King.new([4,7], "black")
       board.game_board[0][7] = Rook.new([0,7], "white")
       board.game_board[4][5] = King.new([4,5], "white")
       expect(board.check_mate?("black")).to eql(true)
      end
    end

  end



end
