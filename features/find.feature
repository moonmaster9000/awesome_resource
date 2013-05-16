Feature: Finding a resource

  Scenario: Resource exists on Server

    Given an article resource exists at "http://localhost:3001/articles/1"

    When I call `Article.find(1)`

    And the server returns a 200 response with the following payload:
      """
        {
          "article": {
            "id": 1,
            "title": "foo"
          }
        }
      """

    Then the find method should return a resource equivalent to the following:
      """
        Article.new(
          id: 1,
          title: "foo"
        )
      """

  Scenario: Resource does not exist on server
    When I call `Article.find(1)`

    And the server returns a 404 response from a GET request to "http://localhost:3001/articles/1"

    Then the find method should raise an AwesomeResource::NotFound exception
