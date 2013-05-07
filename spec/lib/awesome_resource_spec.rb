require_relative '../../lib/awesome_resource'
require_relative '../../features/support/models/article'

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