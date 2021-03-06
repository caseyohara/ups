module UPS
  class Address
    attr_accessor :address1, :address2, :city, :state, :zip, :country

    def initialize(address={})
      @address1 = address[:address1]
      @address2 = address[:address2]
      @city = address[:city]
      @state = address[:state]
      @zip = address[:zip]
      @country = address[:country]
    end

    def valid?
      return false if response.has_key? 'NoCandidatesIndicator'
      return false if response.has_key? 'AmbiguousAddressIndicator'
      response.has_key?('ValidAddressIndicator')
    end

    def recommendations
      return [] if valid?
      recommendations = [response.fetch('AddressKeyFormat', [])].flatten(1)
      recommendations.map do |recommendation|
        RecommendedAddress.new(recommendation)
      end
    end

    def response
      @response ||= API::AddressValidationRequest.new(self).response
    end
  end

  class RecommendedAddress < Address
    def initialize(recommendation)
      address1 = if recommendation['AddressLine'].kind_of? Array
        recommendation['AddressLine'][0]
      else
        recommendation['AddressLine']
      end

      address2 = if recommendation['AddressLine'].kind_of? Array
        recommendation['AddressLine'][1]
      else
        nil
      end

      city = recommendation['PoliticalDivision2']
      state = recommendation['PoliticalDivision1']
      zip = recommendation['PostcodePrimaryLow']
      country = recommendation['CountryCode']

      super(:address1 => address1,
            :address2 => address2,
            :city => city,
            :state => state,
            :zip => zip,
            :country => country)
    end
  end
end
