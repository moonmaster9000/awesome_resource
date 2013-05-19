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
          ).body.should == {"errors" => {"foo" => ["bar"]}}
        end
      end
    end

    describe ".get" do
      context "when the server returns a 404" do
        before do
          WebMock.stub_request(:get, 'www.example.com').to_return(
            status: 404
          )
        end

        it "raises an AwesomeResource::NotFound exception" do
          expect {
            Client.get(
              "http://www.example.com"
            )
          }.to raise_exception(AwesomeResource::NotFound)
        end
      end
    end

    describe ".put" do
      context "when the server returns a 204 with no body" do
        before do
          WebMock.stub_request(:put, 'www.example.com').to_return(
            status: 204,
            body: nil
          )
        end

        it "should return the body with the proper status code" do
          Client.put(
            location: "http://www.example.com",
            body: {}
          ).body.should be_nil
        end
      end

      context "when the server returns a 422" do
        before do
          WebMock.stub_request(:put, 'www.example.com').to_return(
            status: 422,
            body: '{"errors": "are bad"}'
          )
        end

        it "should return the body with the proper status code" do
          put = Client.put(
            location: "http://www.example.com",
            body: {}
          )

          put.body.should        == {"errors" => "are bad"}
          put.status.should  == 422
        end
      end
    end
  end
end
