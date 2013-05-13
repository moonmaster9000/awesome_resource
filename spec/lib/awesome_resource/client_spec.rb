require_relative "../../../lib/awesome_resource/client"
require "webmock"

module AwesomeResource
  describe Client do
    describe ".post" do
      context "when the server returns a 422 with an errors object literal" do
        before do
          WebMock.stub_request(:post, 'www.example.com').to_return(
            status: 422,
            body: '{"errors": {"foo": ["bar"]}}'
          )
        end

        it "returns a response object containing the response body" do
          Client.post(
            location: "http://www.example.com",
            body: {}
          ).payload.should == {"errors" => {"foo" => ["bar"]}}
        end
      end
    end
  end
end
