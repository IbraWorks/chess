require "king.rb"

describe King do

  describe "#get_poss_moves" do

    context "black king is at [0,4]" do
      let(:king){King.new([0,4], "white")}

      it "returns [ [1,4],[0,5],[0,3],[1,5],[1,3] ]" do
        expect(king.get_poss_moves).to eql([[1,4],[0,5],[0,3],[1,5],[1,3]])
      end
    end

  end
end
