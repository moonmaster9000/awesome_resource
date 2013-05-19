require "awesome_resource/client/response"
require "rest-client"
require "json"
require "active_support/core_ext/string"

module AwesomeResource
  class NotFound < StandardError; end

  class Client
    class << self
      def post(location: location, body: body)
        request method: :post, location: location, body: body
      end

      def put(location: location, body: body)
        request method: :put, location: location, body: body
      end

      def get(location)
        request method: :get, location: location
      end

      private
      def request(method: method, location: location, body: nil)
        begin
          if body
            response = RestClient.send(method, location, JSON.generate(body), "Content-Type" => "application/json")
          else
            response = RestClient.send(method, location, "Content-Type" => "application/json")
          end

          Response.new(
            status: response.code,
            body: response.blank? ? nil: JSON.parse(response)
          )

        rescue RestClient::ResourceNotFound
          raise AwesomeResource::NotFound

        rescue RestClient::UnprocessableEntity => e
          Response.new(
            status: e.http_code,
            body: JSON.parse(e.http_body)
          )
        end
      end
    end
  end
end