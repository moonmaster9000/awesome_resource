Feature: Proxy Configuration

  Background:
    Given a rails site exists accepting posts at "http://localhost:3001/articles"
    And I have configured AwesomeResource to post to that site

  Scenario: Valid proxy configured
    Given a proxy is running at "http://localhost:4000" requiring username "proxy" and password "proxypassword"

    And I have configured AwesomeResource to use that proxy:
    """
      AwesomeResource.config do
        proxy -> { "http://proxy:proxypassword@localhost:4000" }
      end
    """

    When I attempt to create a resource:
    """
      Article.create title: "foo"
    """

    Then the server should receive the POST via the proxy