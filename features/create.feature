Feature: Creating a resource

  Scenario: Endpoint responds with 201
    Given a rails site exists accepting posts at "http://localhost:3001/articles"

    When I call create on an Article model:
      """
        Article.create title: "foo"
      """

    Then the Article model should successfully POST the following JSON to "http://localhost:3001/articles":
      """
        {
          "article": {
            "title": "foo"
          }
        }
      """


    When I call the `all` method on the Article model

    Then the rails app should respond to a GET request to "http://localhost:3001/articles" with the following JSON:
      """
        {
          "articles": [
            {
              "title": "foo",
              "id": 1
            }
          ]
        }
      """

    And the `all` method should return the equivalent of:
    """
      [
        Article.new(
          id: 1,
          title: "foo"
        )
      ]
    """