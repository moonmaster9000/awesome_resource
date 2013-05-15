require 'lib/awesome_resource/awesome_resource'
require 'fixtures/models/article'

describe AwesomeResource do
  describe '.create' do
    context "the client returns failures" do
      before do
        AwesomeResource.client.stub(:post).and_return AwesomeResource::Client::Response.new(response_code: 422, payload: {"errors" => {"title" => ["must be present."]}})
      end

      it "should return an invalid instance of the model" do
        Article.create.should be_invalid
      end

      it "should have the appropriate errors" do
        Article.create.errors["title"].should == ["must be present."]
      end
    end
  end

  describe '.find' do
    subject { Article.find(1).attributes }

    before do
      AwesomeResource.client.stub(:get).and_return(
        AwesomeResource::Client::Response.new(
          response_code: response_code,
          payload: payload
        )
      )
    end

    context "the http client returns a 200 response with a payload" do
      let(:response_code) { 200 }
      let(:payload) do { "article" => { "title" => "foo" } } end

      it "returns an instance of the model with the payload's attributes" do
        should == { "title" => "foo" }
      end
    end
  end

  describe 'attributes' do
    it "responds to attributes regardless of whether they are created with string or symbol keys" do
      Article.new("foo" => "bar").foo.should == "bar"
      Article.new(foo: "bar").foo.should == "bar"
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
