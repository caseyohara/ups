require 'spec_helper'

def address
  UPS::Address.new(:address1 => "1285 Avenue of the Americas",
                   :city => "New York",
                   :state => "NY",
                   :zip => "10019",
                   :country => "US")
end

def valid_address
  address
end

def ambiguous_address
  address = valid_address
  address.zip = "10018"
  address
end

def invalid_address
  address = valid_address
  address.city = "asdf"
  address.state = "hjkl"
  address.zip = "00000"
  address
end

describe UPS::Address, '#valid?' do
  it "returns true when it is a valid address" do
    VCR.use_cassette :valid_address do
      valid_address.valid?.should == true
    end
  end

  it "returns false when it is an ambiguous address" do
    VCR.use_cassette :ambiguous_address do
      ambiguous_address.valid?.should == false
    end
  end

  it "returns false when it is invalid" do
    VCR.use_cassette :invalid_address do
      invalid_address.valid?.should == false
    end
  end
end


describe UPS::Address, '#recommendations' do
  it "returns recommended alternative addresses" do
    VCR.use_cassette :ambiguous_address do
      recommended_address = ambiguous_address.recommendations[0]
      recommended_address.address1.should == "1285 AVENUE OF AMERICAS"
      recommended_address.city.should == "NEW YORK"
      recommended_address.state.should == "NY"
      recommended_address.zip.should == "10019"
      recommended_address.country.should == "US"
    end
  end

  it "returns empty when there are no recommendations" do
    VCR.use_cassette :valid_address do
      recommendations = valid_address.recommendations
      recommendations.should == []
    end
  end

end

