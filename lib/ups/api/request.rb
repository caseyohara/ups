module UPS
  module API
    class Request
      def request
        @request ||= begin
          Typhoeus::Request.new API_URL, :body    => xml,
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
          Hash.from_xml(response.body)
        end
      end

      def xml
        access_request_header
      end

      def access_request_header
        Nokogiri::XML::Builder.new do |xml|
          xml.AccessRequest("xml:lang" => "en-US") {
            xml.AccessLicenseNumber API_KEY
            xml.UserId USER_ID
            xml.Password PASSWORD
          }
        end.to_xml
      end

    end
  end
end

