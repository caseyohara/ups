require 'spec_helper'

describe UPS, 'version' do
  it 'should have a version number' do
    UPS::VERSION.should_not be_nil
  end
end

describe UPS, '.configure' do
  it 'saves the settings' do
    UPS.configure do |config|
      config.api_key = ENV['UPS_API_KEY']
      config.user_id = ENV['UPS_USER_ID']
      config.password = ENV['UPS_PASSWORD']
    end

    UPS::API_KEY.should == ENV['UPS_API_KEY']
    UPS::USER_ID.should == ENV['UPS_USER_ID']
    UPS::PASSWORD.should == ENV['UPS_PASSWORD']
  end
end
