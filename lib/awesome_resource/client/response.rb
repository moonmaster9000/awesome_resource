module AwesomeResource
  class Client
    class Response
      attr_reader :body, :status

      def initialize(body: body, status: status)
        @body = body
        @status = status
      end
    end
  end
end