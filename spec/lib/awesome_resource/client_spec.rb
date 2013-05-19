require_relative "../../../lib/awesome_resource/client"
require "webmock"

module AwesomeResource
  describe Client do
    shared_examples_for "Unrecoverable Errors" do
      before do
        WebMock.stub_request(method, 'www.example.com').to_return(
          status: status,
          body: nil
        )
      end

      subject {
        begin
          arguments = { location: "http://www.example.com" }
          arguments = arguments.merge(body: {}) unless method == :get
          Client.send(method, arguments)
        rescue Exception => e
          e
        end.class
      }

      AwesomeResource::EXCEPTION_CODES.keys.each do |code|
        context "#{code} error" do
          let(:status) { code }

          it { should == AwesomeResource::EXCEPTIONS[code] }
        end
      end
    end

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

      context "the server responds with any other response code" do
        let(:method) { :post }
        it_behaves_like "Unrecoverable Errors"
      end

    end

    describe ".get" do
      context "the server responds with any other response code" do
        let(:method) { :get }
        it_behaves_like "Unrecoverable Errors"
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

          put.body.should == {"errors" => "are bad"}
          put.status.should == 422
        end
      end

      context "the server responds with any other response code" do
        let(:method) { :put }
        it_behaves_like "Unrecoverable Errors"
      end
    end
  end
end
