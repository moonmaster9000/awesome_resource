require 'awesome_resource/configuration'

module AwesomeResource
  describe Configuration do
    let(:env) { "default" }
    let(:config) { Configuration.new }

    before { AwesomeResource.stub(:env).and_return env }

    describe "#proxy" do
      context "no proxy set" do
        it "should be nil" do
          config.proxy.should be_nil
        end
      end

      context "proxy set with lambda" do
        before do
          config.proxy -> { "proxy!" }
        end

        it "should return the lambda's value" do
          config.proxy.should == "proxy!"
        end
      end

      context "proxy set in current environment" do
        before do
          config.send(env) do
            proxy -> { "environment specific proxy!" }
          end
        end

        it "should return the current environment's proxy" do
          config.proxy.should == "environment specific proxy!"
        end

      end

      context "proxy set in different environment" do
        before do
          config.some_other_environment do
            proxy -> { "some other environment's proxy!" }
          end
        end

        it "should be nil" do
          config.proxy.should be_nil
        end
      end
    end

    describe "#site" do
      context "default site set with no environment specific override" do
        let(:env) { "production" }

        it "should return the default site" do
          config.site -> { "default site" }
          config.site.should == "default site"
        end
      end

      context "called within an environment block other than test" do
        let(:env) { "production" }

        it "should set the site for that specific environment" do
          config.production do
            site -> { "production site" }
          end

          config.site -> { "default site" }

          config.site.should == "production site"
        end
      end

      context "called within 'test' environment block" do
        let(:env) { "test" }

        it "should set the site for that specific environment" do
          config.test do
            site -> { "test site" }
          end

          config.site -> { "default site" }

          config.site.should == "test site"
        end
      end

      context "called outside environment block" do
        context "set with lambda" do
          it "returns result of lambda" do
            config.site -> { "foo" }
            config.site.should == "foo"
          end
        end

        context "not set" do
          it "raises a SiteRequired exception" do
            expect { config.site }.to raise_exception(SiteRequired)
          end
        end
      end
    end
  end
end