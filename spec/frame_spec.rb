require './bowling.rb'

describe Frame do
  let(:frame) { Frame.new }

  it "should respond to first_throw" do
    expect(frame).to respond_to(:first_throw)
  end

  it "should respond to second_throw" do
    expect(frame).to respond_to(:second_throw)
  end

  it "should respond to score" do
    expect(frame).to respond_to(:score)
  end
end
