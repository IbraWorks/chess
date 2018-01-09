require "bishop.rb"

describe Bishop do

  describe "#get_poss_moves" do

    context "when a black bishop is at position [0,2]" do
      let(:bishop){Bishop.new([0,2], "black")}
      it "returns [[1,1],[2,0],[1,3],[2,4],[3,5],[4,6],[5,7]]" do
        expect(bishop.get_poss_moves).to eql([[1,1],[2,0],[1,3],[2,4],[3,5],[4,6],[5,7]])
      end
    end

    context "when a white bishop is at position [7,2]" do
      let(:bishop){Bishop.new([7,2], "white")}
      it "[[6,1],[5,0],[6,3],[5,4],[4,5],[3,6],[2,7]]" do
        expect(bishop.get_poss_moves).to eql([[6,1],[5,0],[6,3],[5,4],[4,5],[3,6],[2,7]])
      end
    end
  end
end
