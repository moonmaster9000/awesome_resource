require 'lib/awesome_resource/awesome_resource'
require 'fixtures/models/article'

describe AwesomeResource do
  describe ".collection_endpoint" do
    before { AwesomeResource.reset_config! }

    subject { Article.collection_endpoint }

    context "when the configured site has been set with a trailing slash" do
      before { AwesomeResource.config { site -> { "http://localhost:3001/"} } }

      it { should == "http://localhost:3001/articles" }
    end

    context "when the configured site has NOT been set with a trailing slash" do
      before { AwesomeResource.config { site -> { "http://localhost:3001"} } }

      it { should == "http://localhost:3001/articles" }
    end
  end

  describe '#destroy' do
    context "the client returns a 204 response" do
      before do
        AwesomeResource.client.should_receive(:delete).and_return AwesomeResource::Client::Response.new(
          status: 204,
          body: nil
        )
      end

      it "should return true" do
        Article.new(id: 1).destroy.should be_true
      end
    end

    context "the client returns any other response" do
      before do
        AwesomeResource.client.should_receive(:delete).and_return AwesomeResource::Client::Response.new(
          status: 401,
          body: nil
        )
      end

      it "should return false" do
        Article.new(id: 1).destroy.should be_false
      end
    end
  end

  describe '.create' do
    context "the client returns failures" do
      before do
        AwesomeResource.client.stub(:post).and_return AwesomeResource::Client::Response.new(
          status: 422,
          body: {
            "errors" => {
              "title" => ["must be present."]
            }
          }
        )
      end

      it "should return an invalid instance of the model" do
        Article.create.should be_invalid
      end

      it "should have the appropriate errors" do
        Article.create.errors["title"].should == ["must be present."]
      end
    end
  end

  describe "#save" do
    context "the instance already has an ID" do
      let(:article) do
        Article.new(
          id: 1,
          title: "foo"
        )
      end

      context "the server responds to a PUT with a 204" do
        let(:response) do
          AwesomeResource::Client::Response.new(
            status: 204,
            body: nil
          )
        end

        it "PUTs the attributes to the resource" do
          AwesomeResource.client.should_receive(:put).with(hash_including(
            location: "http://localhost:3001/articles/1",
            body: { "article" => article.attributes }
          )).and_return(response)

          original_attributes = article.attributes

          article.save

          article.attributes.should == original_attributes
        end
      end

      context "the server responds to a PUT with 422 failure" do
        let(:response) do
          AwesomeResource::Client::Response.new(
            status: 422,
            body: {
              "errors" => {
                "base" => "there was an error"
              }
            }
          )
        end

        it "PUTs the attributes to the resource and captures the errors" do
          AwesomeResource.client.should_receive(:put).with(hash_including(
            location: "http://localhost:3001/articles/1",
            body: { "article" => article.attributes }
          )).and_return(response)

          attributes_before = article.attributes

          article.save

          article.attributes.should == attributes_before

          article.errors["base"].should == "there was an error"

          article.valid?.should be_false
        end
      end
    end

    context "the instance does not have an ID yet" do
      let(:article) { Article.new(title: "foo") }

      context "the server responds with success" do
        let(:response) do
          AwesomeResource::Client::Response.new(
            status: 201,
            body: {
              "id" => 1,
              "title" => "foo",
              "updated_at" => "now"
            }
          )
        end

        it "should POST the attributes to the server" do
          AwesomeResource.client.should_receive(:post).with(hash_including(
            location: "http://localhost:3001/articles",
            body: { "article" => article.attributes }
          )).and_return(response)

          article.save

          article.attributes.should == response.body
        end
      end
      context "the server responds with a 422" do
        let(:response) do
          AwesomeResource::Client::Response.new(
            status: 422,
            body: {
              "errors" =>  {
                "foo" => "bar"
              }
            }
          )
        end

        it "should POST the attributes to the server" do
          AwesomeResource.client.should_receive(:post).with(hash_including(
            location: "http://localhost:3001/articles",
            body: { "article" => article.attributes }
          )).and_return(response)

          original_attributes = article.attributes

          article.save

          article.attributes.should == original_attributes

          article.errors.should == response.body["errors"]
        end
      end
    end
  end

  describe '.find' do
    subject { Article.find(1).attributes }

    before do
      AwesomeResource.client.stub(:get).and_return(
        AwesomeResource::Client::Response.new(
          status: status,
          body: body
        )
      )
    end

    context "the http client returns a 200 response with a body" do
      let(:status) { 200 }
      let(:body) do { "article" => { "title" => "foo" } } end

      it "returns an instance of the model with the body's attributes" do
        should == { "title" => "foo" }
      end
    end
  end

  describe 'attributes' do
    it "responds to attributes regardless of whether they are created with string or symbol keys" do
      Article.new("foo" => "bar").foo.should == "bar"
      Article.new(foo: "bar").foo.should == "bar"
    end

    it "responds to attribute writer methods" do
      article_class = Class.new do
        include AwesomeResource
      end

      article = article_class.new("title" => "Fun")
      article.title.should == "Fun"

      article.title = 'Fun Times!'
      article.title.should == 'Fun Times!'

      expect { article.unknown_attribute }.to raise_exception
    end
  end

  describe '#==' do
    let(:article1) { Article.new(article_1_attributes)  }
    let(:article2) { Article.new(article_2_attributes) }

    subject { article1 == article2 }

    context "all attributes are equal on both resource instances" do
      let(:article_1_attributes) do { a: 1, b: 2 } end
      let(:article_2_attributes) do { a: 1, b: 2 } end

      it { should be_true }
    end

    context "all attributes are equal on both resource instances" do
      let(:article_1_attributes) do { a: 1, b: 2 } end
      let(:article_2_attributes) do { a: 1 } end

      it { should be_false }
    end
  end
end
