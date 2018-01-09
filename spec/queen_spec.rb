require "queen.rb"

describe Queen do


  describe "#get_poss_moves" do

    context "when black queen is at [0,3]" do
      let(:queen) { Queen.new([0,3], "black") }

      it "returns [[1, 2], [2, 1], [3, 0], [1, 4], [2, 5], [3, 6], [4, 7], [1, 3], [2, 3], [3, 3], [4, 3],
      [5, 3], [6, 3], [7, 3], [0, 4], [0, 5], [0, 6], [0, 7], [0, 2], [0, 1], [0, 0]]" do
        expect(queen.get_poss_moves).to eql([[1, 2], [2, 1], [3, 0], [1, 4], [2, 5], [3, 6], [4, 7], [1, 3], [2, 3], [3, 3], [4, 3],
        [5, 3], [6, 3], [7, 3], [0, 4], [0, 5], [0, 6], [0, 7], [0, 2], [0, 1], [0, 0]])
      end
    end

  end
end
