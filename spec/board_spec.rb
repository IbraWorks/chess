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
      it "moves black rook to [5,0] and captures white rook" do
        board.move_piece(0,0,7,0)
        expect(board.game_board[0][0]).to eql(nil)
        expect(board.game_board[7][0].class).to eql(Rook)
        expect(board.game_board[7][0].colour).to eql("black")
      end
    end

    context "given black pawn moves from [6,0] to [7,0]" do
      it "changes the @promotion_allowed variable to true" do
        board.game_board[6][0] = Pawn.new([6,0], "black")
        expect(board.game_board[6][0].promotion_allowed).to eql(false)
        board.move_piece(6,0,7,0)
        expect(board.game_board[7][0].promotion_allowed).to eql(true)
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
    context "given black rook moves from [0,0] to [2,0] where there is a piece in between" do
      it "returns false" do
        expect(board.valid_move?(0,0,2,0)).to eql(false)
      end
    end
    context "given black rook moves from [0,0] to an empty [1,0]" do
      it "returns true" do
        board.game_board[1][0] = nil
        expect(board.valid_move?(0,0,1,0)).to eql(true)
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

    context "given black bishop moves and causes it's king at [0,4] to be in check" do
      it "returns false" do
        board.game_board[1][4] = Bishop.new([1,4], "black") #replace pawn with bishop so it can move out of the way easily
        board.game_board[4][4] = Rook.new([4,4], "white") # rook will check king
        expect(board.valid_move?(1,4,2,5)).to eql(false)
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

  end

  describe "#check_mate?"
  let(:board){Board.new}

  context "given a black king on starting board" do
    it "returns false" do
      king_location = board.locate_king("black").location
      expect(board.check_mate?("black")).to eql(false)
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

  context "given a black king at [0,4] in check by white knight at [2,5] with no black knight" do
    it "returns true" do
      board.game_board[0][6] = nil #erase knight that can save king
      board.game_board[1][4] = Knight.new([1,4], "black") #just to test
      board.game_board[1][6] = nil # erase pawn that can save king
      board.game_board[2][5] = Knight.new([2,5], "white") #attacking knight
      expect(board.check_mate?("black")).to eql(true)
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

end
