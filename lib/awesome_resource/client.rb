require "awesome_resource/client/response"
require "rest-client"
require "json"
require "active_support/core_ext/string"

module AwesomeResource
  class NotFound < StandardError; end

  class Client
    class << self
      def post(location: location, body: body)
        begin
          response = RestClient.post(location, JSON.generate(body), "Content-Type" => "application/json")

          Response.new(
            status: response.code,
            body: JSON.parse(response)
          )
        rescue RestClient::Exception => e
          Response.new(
            status: e.http_code,
            body: JSON.parse(e.http_body)
          )
        end
      end

      def put(location: location, body: body)
        begin
          response = RestClient.put(location, JSON.generate(body), "Content-Type" => "application/json")

          Response.new(
            status: response.code,
            body: response.blank? ? nil: JSON.parse(response)
          )

        rescue RestClient::Exception => e
          Response.new(
            status: e.http_code,
            body: JSON.parse(e.http_body)
          )
        end
      end

      def get(location)
        begin
          response = RestClient.get(location, "Content-Type" => "application/json")

          Response.new(
            status: response.code,
            body: JSON.parse(response)
          )

        rescue RestClient::ResourceNotFound
          raise AwesomeResource::NotFound
        end
      end
    end
  end
end