require "knight.rb"

describe Knight do
  subject(:knight){Knight.new([0,1], "black")}

  context "when initialized as 'black'" do
    it "returns \U+265E as icon " do
      expect(knight.icon).to eql("\U+265E")
    end
  end

  describe "#get_poss_moves" do

    context "when black knight is in position [0,1]" do
      it "returns [ [2,0], [2,2], [1,3] ]" do
        expect(knight.get_poss_moves).to eql([[2,0], [2,2], [1,3]])
      end
    end
    
  end


end
