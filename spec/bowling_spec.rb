require './bowling.rb'

describe Bowling do
  let(:bowling) { Bowling.new }

  context "when input is invalid" do
    it "should return 'No input found' error message" do
      expect{ bowling.hits = '' }.to raise_error(ArgumentError, '[Error] No input found.')
    end

    it "should return 'Incorrect format' error message" do
      input = '1,2,3,4,5,6,7,8,9,10,10,10,'
      expect{ bowling.hits = input }.to raise_error(ArgumentError, '[Error] Incorrect format.')
      input = ',1,2,3,4,5,6,7,8,9,10,10,10'
      expect{ bowling.hits = input }.to raise_error(ArgumentError, '[Error] Incorrect format.')
      input = ',1, 2,3, 4,50 ,6,71,8,90,10,10,10'
      expect{ bowling.hits = input }.to raise_error(ArgumentError, '[Error] Incorrect format.')
      input = '1, a,3, 4,5 ,6,7,8,9,10,10,10'
      expect{ bowling.hits = input }.to raise_error(ArgumentError, '[Error] Incorrect format.')
    end

    it "should return 'More than 21 thorws' error message" do
      input = Array.new(22, 5).join(',') # 22 throws
      expect{ bowling.hits = input }.to raise_error(ArgumentError, '[Error] More than 21 throws.')
    end
  end

  context "when input is valid" do
    it "should return max score" do
      bowling.hits = '10,10,10,10,10,10,10,10,10,10,10,10'
      expect(bowling.score).to eq(300)
    end

    it "should return score even the game is not yet finished" do
      bowling.hits = '1,2,3,4,5,5'
      expect(bowling.score).to eq(20)
    end

    it "should return score with strike or spare handled" do
      bowling.hits = '9,1,10,8,0,2'
      expect(bowling.score).to eq(48)
      bowling.hits = '10,0,0,9,1,0,0,8,2,0,0,7,3,0,0,6,4,0,0'
      expect(bowling.score).to eq(50)
      bowling.hits = '5,4,6,2,10,3,4,0,10,2,3'
      expect(bowling.score).to eq(58)
    end

    it "should return breakdown" do
      bowling.hits = '5,4,6,2,10,3,4,0,10,2,3'
      expect{ bowling.breakdown }.to output.to_stdout
    end
  end

  context "when input is re-assigned" do
    it "should return new hits" do
      bowling.hits = '10,10,10,10,10,10,10,10,10,10,10,10'
      expect(bowling.hits).to eq(Array.new(12, 10))
      bowling.hits = '1,2,3'
      expect(bowling.hits).to eq([1, 2, 3])
    end

    it "should return new score" do
      bowling.hits = '10,10,10,10,10,10,10,10,10,10,10,10'
      expect(bowling.score).to eq(300)
      bowling.hits = '1,2,3'
      expect(bowling.score).to eq(6)
    end
  end
end
