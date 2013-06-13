Feature: Environment-Specific Configuration

  Scenario: Environment specific site configuration

    Given a rails site exists at "http://localhost:3001/"

    Given I change the default 'Rails.env' environment lookup to the following:
    """
      AwesomeResource.env = -> { "production" }
    """

    And I configure a default site for AwesomeResource for different environments:
    """
      AwesomeResource.config do
        production do
          site -> { "http://localhost:3001" }
        end

        test do
          site -> { "http://localhost:3002" }
        end
      end
    """

    When I create a resource:
    """
      Article.create(title: "production article")
    """

    Then AwesomeResource should POST the following body to "http://localhost:3001/articles"
    """
      {
        "article": {
          "title": "production article"
        }
      }
    """