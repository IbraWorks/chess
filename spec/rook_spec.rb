require "rook.rb"

describe Rook do

  describe "#get_poss_moves" do

    context "when black rook is at [0,0]" do
      let(:rook) { Rook.new([0,0], "black") }

      it "returns [[1,0],[2,0],[3,0],[4,0],[5,0],[6,0],[7,0],[0,1],[0,2],[0,3],[0,4],[0,5],[0,6],[0,7]]" do
        expect(rook.get_poss_moves).to eql([[1,0],[2,0],[3,0],[4,0],[5,0],[6,0],[7,0],[0,1],[0,2],[0,3],[0,4],[0,5],[0,6],[0,7]])
      end
    end

    context "when white rook it at [3,3]" do
      let(:rook) {Rook.new([3,3], "white")}

      it "returns [ [4,3],[5,3],[6,3],[7,3],[2,3],[1,3],[0,3],[3,4],[3,5],[3,6],[3,7],[3,2],[3,1],[3,0] ] " do
        expect(rook.get_poss_moves).to eql([[4,3],[5,3],[6,3],[7,3],[2,3],[1,3],[0,3],[3,4],[3,5],[3,6],[3,7],[3,2],[3,1],[3,0]])
      end
    end

  end

end
