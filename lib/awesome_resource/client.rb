require "awesome_resource/client/response"
require "rest-client"
require "json"

module AwesomeResource
  class Client
    class << self
      def post(location: location, body: body)
        begin
          response = RestClient.post(location, JSON.generate(body), "Content-Type" => "application/json")

          Response.new(
            response_code: response.code,
            payload: JSON.parse(response)
          )
        rescue RestClient::Exception => e
          Response.new(
            response_code: e.http_code,
            payload: JSON.parse(e.http_body)
          )
        end
      end
    end
  end
end