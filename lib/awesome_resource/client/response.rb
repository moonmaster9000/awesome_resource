module AwesomeResource
  class Client
    class Response
      attr_reader :payload, :response_code

      def initialize(payload: payload, response_code: response_code)
        @payload = payload
        @response_code = response_code
      end
    end
  end
end