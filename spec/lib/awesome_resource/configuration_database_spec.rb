require "awesome_resource/configuration_database"
require "fixtures/models/article"

module AwesomeResource
  describe ConfigurationDatabase do
    let(:database) { ConfigurationDatabase.new }
    before { AwesomeResource.stub(:env) }

    context "environment specific configuration" do
      context "custom environment lookup" do
        before { AwesomeResource.stub(:env).and_return "testing" }

        context "default site configured for current environment" do
          before do
            database.testing { site -> { "testing site" } }
            database.production { site -> { "production site" } }
          end

          it "should return that site for any model request" do
            database.site.should == "testing site"
          end
        end
      end
    end

    context "environment agnostic configuration" do
      it "should delegate unscoped attributes to the default configuration" do
        database.site -> { "default site" }
        database.site.should == "default site"
        database.config_for("default").site.should == "default site"
      end

      context "unconfigured model" do
        it "should pull scoped attributes from the default configuration" do
          database.site -> { "default site" }
          database.config_for("Article").site.should == "default site"
        end
      end

      context "configured model" do
        it "should pull scoped attributes from the model's configuration" do
          database.site -> { "default site" }

          database.config_for("Article") do
            site -> { "article site" }
          end

          database.config_for("Article").site.should == "article site"

          database.site.should == "default site"
        end

        it "should work for both the actual class and the string representation of the class" do
          database.site -> { "default site" }

          database.config_for("Article") do
            site -> { "article site" }
          end

          database.config_for(Article).site.should == "article site"

          database.site.should == "default site"
        end
      end
    end

  end
end