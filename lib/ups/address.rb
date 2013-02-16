module UPS
  class Address
    attr_accessor :address1, :city, :state, :zip, :country

    def initialize(address={})
      @address1 = address[:address1]
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
      response['AddressKeyFormat'].map do |recommendation|
        address = self.class.new

        if recommendation['AddressLine'].kind_of? Array
          address.address1 = recommendation['AddressLine'][0]
        else
          address.address1 = recommendation['AddressLine']
        end

        address.city = recommendation['PoliticalDivision2']
        address.state = recommendation['PoliticalDivision1']
        address.zip = recommendation['PostcodePrimaryLow']
        address.country = recommendation['CountryCode']
        address
      end
    end

    def request
      @request ||= begin
        xml = access_request + address_validation_request
        Typhoeus::Request.new API_URL,
                              :body    => xml,
                              :method  => :post,
                              :headers => {"Content-type" => "application/x-www-form-urlencoded"}
      end
    end

    def response
      @response ||= begin
        hydra = Typhoeus::Hydra.new
        hydra.queue(request)
        hydra.run
        response = request.response
        Hash.from_xml(response.body)['AddressValidationResponse']
      end
    end

    def access_request
      @access_request ||= Nokogiri::XML::Builder.new do |xml|
        xml.AccessRequest("xml:lang" => "en-US") {
          xml.AccessLicenseNumber API_KEY
          xml.UserId USER_ID
          xml.Password PASSWORD
        }
      end.to_xml
    end

    def address_validation_request
      @address_validation_request ||= Nokogiri::XML::Builder.new do |xml|
        xml.AddressValidationRequest("xml:lang" => "en-US") {
          xml.Request {
            xml.TransactionReference {
              xml.CustomerContext
              xml.XpciVersion 1.0001
            }
            xml.RequestAction "XAV"
            xml.RequestOption "3"
          }
          xml.MaximumListSize 3
          xml.AddressKeyFormat {
            xml.AddressLine        address1
            xml.PoliticalDivision2 city
            xml.PoliticalDivision1 state
            xml.PostcodePrimaryLow zip
            xml.CountryCode        country
          }
        }
      end.to_xml
    end

  end
end
