require 'spec_helper'

describe Domain do
  it "defines gTLDs" do  
    Domain::TLDS.should == ["kissr.co","com","org","net","info"]
  end
end
