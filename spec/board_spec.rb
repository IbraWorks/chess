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

    context "given black rook moves from [0,0] to an empty [1,0]" do

      it "returns true" do
        board.game_board[1][0] = nil
        expect(board.valid_move?(0,0,1,0)).to eql(true)
      end
    end

  end
end
