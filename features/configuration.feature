Feature: Configuration

  Scenario: Site not set
    Given I do not configure any sites for AwesomeResource to connect to

    When I attempt to create a resource:
    """
      Article.create(title: "foo")
    """

    Then AwesomeResource should raise a SiteRequired exception


  Scenario: Site set
    Given a rails site exists at "http://localhost:3002/"

    And I have configured AwesomeResource to post to that site:
    """
      AwesomeResource.config do
        site -> { "http://localhost:3002" }
      end
    """

    When I create a resource:
    """
      Article.create(title: "foo")
    """

    Then AwesomeResource should POST the following body to "http://localhost:3002/articles"
    """
      {
        "article": {
          "title": "foo"
        }
      }
    """

  Scenario: Site configured for a specific model

    Given a rails site exists at "http://localhost:3002/"

    And I have configured AwesomeResource to post to that site:
    """
      AwesomeResource.config do
        site -> { "http://localhost:3001" }

        config_for "Article" do
          site -> { "http://localhost:3002" }
        end
      end
    """

    When I create a resource:
    """
      Article.create(title: "foo")
    """

    Then AwesomeResource should POST the following body to "http://localhost:3002/articles"
    """
      {
        "article": {
          "title": "foo"
        }
      }
    """