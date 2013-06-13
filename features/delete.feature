Feature: Deleting a resource

  Background:
    Given a rails site exists accepting posts at "http://localhost:3001/articles"

    And I have configured AwesomeResource to post to that site:
    """
      AwesomeResource.config do
        site -> { "http://localhost:3001/" }
      end
    """

  @reset-server-ids
  Scenario: Server responds with 204 OK

    Given an article resource exists at "http://localhost:3001/articles/1"

    When I call the destroy method on this article instance:
    """
      article = Article.find(1)
      article.destroy
    """

    Then AwesomeResource should send a DELETE request to "http://localhost:3001/articles/1"

    And the server should return a 204 response to the DELETE to "http://localhost:3001/articles/1"

    And `Article.find(1)` should raise a ResourceNotFound exception