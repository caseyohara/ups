module UPS
  module API
    class AddressValidationRequest < Request
      attr_reader :address

      def self.for_address(address)
        new(address)
      end

      def initialize(address)
        @address = address
      end

      def response
        super['AddressValidationResponse']
      end

      def xml
        super + address_validation_request_xml
      end

      def address_validation_request_xml
        Nokogiri::XML::Builder.new do |xml|
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
              xml.AddressLine        address.address1
              xml.PoliticalDivision2 address.city
              xml.PoliticalDivision1 address.state
              xml.PostcodePrimaryLow address.zip
              xml.CountryCode        address.country
            }
          }
        end.to_xml
      end

    end
  end
end
