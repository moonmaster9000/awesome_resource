Feature: Model-Specific Configuration

  Scenario: Site configured for a specific model

    Given a rails site exists at "http://localhost:3001/"

    And I have configured AwesomeResource to post to that site:
    """
      AwesomeResource.config do
        site -> { "http://localhost:3002" }

        config_for "Article" do
          site -> { "http://localhost:3001" }
        end
      end
    """

    When I create a resource:
    """
      Article.create(title: "foo")
    """

    Then AwesomeResource should POST the following body to "http://localhost:3001/articles"
    """
      {
        "article": {
          "title": "foo"
        }
      }
    """
