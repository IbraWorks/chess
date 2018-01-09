require "pawn.rb"

describe Pawn do

  describe "#get_poss_moves" do

    context "when black pawn is at location [1,1] and has not moved" do
      let(:pawn){ Pawn.new([1,1], "black") }
      it "returns [[2,1],[3,1],[2,0],[2,2]]" do
        expect(pawn.get_poss_moves).to eql([[2,1],[3,1],[2,2],[2,0]])
      end
    end

    context "black pawn has already moved and is at location [2,2]" do
      let(:pawn){ Pawn.new([2,2], "black") }
      it "returns [ [3,2], [3,3], [3,1] ]" do
        pawn.already_moved = true
        expect(pawn.get_poss_moves).to eql([[3,2],[3,3],[3,1]])
      end
    end

    context "when white pawn is at [6,6] and has not moved" do
      let(:pawn) { Pawn.new([6,6], "white") }
      it "returns [ [5,6],[4,6],[5,7],[5,5] ]" do
        expect(pawn.get_poss_moves).to eql([[5,6],[4,6],[5,7],[5,5]])
      end
    end

    context "when white pawn has already moved and is at location [5,5]" do
      let(:pawn) {Pawn.new([5,5], "white")}
      it "returns [ [4,5],[4,6],[4,4] ]" do
        pawn.already_moved = true
        expect(pawn.get_poss_moves).to eql([[4,5],[4,6],[4,4]])
      end
    end

    context "when black pawn is on edge of board at [1,0]" do
      let(:pawn) {Pawn.new([1,0], "black")}
      it "returns [ [2,0],[3,0],[2,1] ]" do
        expect(pawn.get_poss_moves).to eql([[2,0],[3,0],[2,1]])
      end
    end
  end

end
