require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'ups'
require 'secrets.rb'

UPS.configure do |config|
  config.api_key = ENV['UPS_API_KEY']
  config.user_id = ENV['UPS_USER_ID']
  config.password = ENV['UPS_PASSWORD']
end

