require 'awesome_resource/configuration'

module AwesomeResource
  describe Configuration do
    describe "#site" do
      context "set with lambda" do
        it "returns result of lambda"  do
          config = Configuration.new
          config.site -> { "foo" }
          config.site.should == "foo"
        end
      end

      context "not set" do
        it "raises a SiteRequired exception" do
          expect { Configuration.new.site }.to raise_exception(SiteRequired)
        end
      end
    end
  end
end