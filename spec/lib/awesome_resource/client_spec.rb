require_relative "../../../lib/awesome_resource/client"
require "webmock"

module AwesomeResource
  describe Client do
    let(:client) { Client.new }

    shared_examples_for "Unrecoverable Errors" do
      before do
        RestClient.stub(method).and_return double(
          :response,
          code: status
        )
      end

      subject {
        begin
          arguments = { location: "http://www.example.com" }
          arguments = arguments.merge(body: {}) unless method == :get
          client.send(method, arguments)
        rescue Exception => e
          e
        end.class
      }

      AwesomeResource::UNHANDLED_RESPONSES.keys.each do |code|
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
          client.post(
            location: "http://www.example.com",
            body: {}
          ).body.should == {"errors" => {"foo" => ["bar"]}}
        end
      end

      context "the server responds with any other response code" do
        let(:method) { :post }
        it_behaves_like "Unrecoverable Errors"
      end

      context "newed up with a proxy attribute" do
        let(:client) { Client.new proxy: "http://foo:bar@some.proxy:9191"}

        it "should post to the proxy instead of the final server" do
          WebMock.stub_request(:post, 'some.proxy:9191').to_return(
            status: 201,
            body: '{"proxy": "response"}'
          )

          WebMock.stub_request(:post, 'final.destination.server').to_return(
            status: 201,
            body: '{"destination": "response"}'
          )

          client.post(
            location: "http://final.destination.server",
            body: {"hi" => "there"}
          ).body.should == {"destination" => "response"}
        end
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
          client.put(
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
          put = client.put(
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

    describe ".delete" do
      context "the server responds with a 204" do
        before do
          WebMock.stub_request(:delete, "http://www.example.com").to_return(
            status: 204,
            body: nil
          )
        end

        it "returns an empty body with a 204 status" do
          response = client.delete(location: "http://www.example.com")
          response.status.should == 204
          response.body.should be_nil
        end
      end
    end
  end
end
