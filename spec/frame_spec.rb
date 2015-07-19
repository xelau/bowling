require './bowling.rb'

describe Frame do
  let(:frame) { Frame.new }

  it "should respond to number" do
    expect(frame).to respond_to(:number)
  end

  it "should respond to first_throw" do
    expect(frame).to respond_to(:first_throw)
  end

  it "should respond to second_throw" do
    expect(frame).to respond_to(:second_throw)
  end

  it "should respond to extra_throw" do
    expect(frame).to respond_to(:extra_throw)
  end

  it "should respond to score" do
    expect(frame).to respond_to(:score)
  end

  it "should able to determine strike" do
    expect(frame.strike?).to be_falsey
    frame.first_throw = 10
    expect(frame.strike?).to be_truthy
  end

  it "should able to determine spare" do
    expect(frame.spare?).to be_falsey

    frame.first_throw = 10
    expect(frame.spare?).to be_falsey

    frame.first_throw = 3
    frame.second_throw = 7
    expect(frame.spare?).to be_truthy

    frame.first_throw = 0
    frame.second_throw = 10
    expect(frame.spare?).to be_truthy
  end
end
