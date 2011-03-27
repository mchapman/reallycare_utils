require File.join(File.dirname(__FILE__), 'spec_helper')

class TestBitmaskBase
  def [](name)
    @attributes ||= {}
    @attributes[name]
  end
  
  def []=(name, value)
    @attributes ||= {}
    @attributes[name] = value
  end
end

class TestBitmask < TestBitmaskBase
  include ReallycareUtils::Bitmask
  has_bitmask :status, [:pending, :new, :finished]
end

describe "Bitmask" do
  it "should be able to set bitmask constants" do
    o = TestBitmask.new
    o.add_status :pending
    o[:status].should == 1
    o.add_status :new
    o[:status].should == 3
  end
  
  it "should be able to check if bitmask constants are set" do
    o = TestBitmask.new
    o.add_status :pending
    o.has_status?(:pending).should be_true
    o.has_status?(:new).should be_false
  end
  
  it "should be able to unset bitmask constants" do
    o = TestBitmask.new
    o.add_status :pending
    o.has_status?(:pending).should be_true
    o.remove_status :pending
    o.has_status?(:pending).should be_false
  end

  it "should save when setting if the second parameter is true" do
    o = TestBitmask.new
    o.should_receive("save!".to_sym).once
    o.add_status(:pending, true)
  end
  
  it "should not save when setting if the second parameter is false or missing" do
    o = TestBitmask.new
    o.should_not_receive("save!".to_sym)
    o.add_status(:pending, false)
    o.add_status(:pending)
  end
  
  it "should save when unsetting if the second parameter is true" do
    o = TestBitmask.new
    o.should_receive("save!".to_sym).once
    o.add_status(:pending, true)
  end
  
  it "should not save when unsetting if the second parameter is false or missing" do
    o = TestBitmask.new
    o.should_not_receive("save!".to_sym)
    o.add_status(:pending)
    o.remove_status(:pending, false)
    o.add_status(:pending)
    o.remove_status(:pending)
  end

end