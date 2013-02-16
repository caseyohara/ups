require "ostruct"
require 'typhoeus'
require 'active_support/all'
require 'nokogiri'
require "ups/version"
require "ups/address"
require "ups/api"

module UPS
  API_URL = "https://onlinetools.ups.com/ups.app/xml/XAV"

  def self.configure
    config = OpenStruct.new
    yield(config)
    const_set(:API_KEY, config.api_key)
    const_set(:USER_ID, config.user_id)
    const_set(:PASSWORD, config.password)
  end
end

