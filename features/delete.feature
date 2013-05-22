Feature: Deleting a resource

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