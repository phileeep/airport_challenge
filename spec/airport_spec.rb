require "airport.rb"

describe Airport do 
  it "It responds to land plane" do 
    expect(subject).to respond_to(:land)
  end
  it "Checks there is a hangar to land in" do 
    expect(subject.hangar).to eq([])
  end
  it "Checks that a plane can take off" do
    expect(subject).to respond_to(:take_off)
  end
  it "Will not land a plane if the airport is full" do
    allow(subject).to receive(:stormy?).and_return(false)
    Airport::HANGAR_CAPACITY.times { subject.land Plane.new }
    expect { subject.land(Plane.new) }.to raise_error(RuntimeError, 'Cannot land plane, Airport is full')
  end
  it "Allows the default capacity of the airport to be overwritten" do
    expect(Airport.new(27).capacity).to eq(27)
  end
  it "Checks that the weather can be stormy" do
    expect(subject.stormy?(5)).to eq(true)
  end
  it "Will not take a plane off if the weather is stormy" do 
    allow(subject).to receive(:stormy?).and_return(true)
    expect { subject.take_off(Plane.new) }.to raise_error(RuntimeError, 'It is stormy cannot takeoff')
  end
  it "Will not land a plane if the weather is stormy" do 
    allow(subject).to receive(:stormy?).and_return(true)
    expect { subject.land(Plane.new) }.to raise_error(RuntimeError, 'It is stormy cannot land')
  end
  it "Will not land a plane that is already landed" do
    plane = Plane.new
    allow(plane).to receive(:landed) { true }
    expect { subject.land(plane) }.to raise_error(RuntimeError, 'Plane is currently landed')
  end
  it "Will not take off a plane that is already in the air" do 
    plane = Plane.new
    allow(subject).to receive(:stormy?).and_return(false)
    allow(plane).to receive(:flying) { true }
    expect { subject.take_off(plane) }.to raise_error(RuntimeError, 'Plane is currently flying, cannot take off')
  end
  it "Checks that the plane that has taken off has left the hangar" do
    allow(subject).to receive(:stormy?).and_return(false)
    5.times { subject.land(Plane.new) }
    subject.take_off(Plane.new)
    expect(subject.hangar.size).to eq(4)
  end
end
