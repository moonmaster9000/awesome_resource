Feature: Update a resource

  Scenario: Resource pre-existing

    Given an article resource exists at "http://localhost:3001/articles/1"

    When I update the article:
      """
        article = Article.find(1)
        article.title = 'new title!'
        article.save
      """

    Then AwesomeResource should PUT the following body to "http://localhost:3001/articles/1"
      """
        {
          "article": {
            "id": 1,
            "title": "new title!"
          }
        }
      """

    And the server should return a 204 response to the PUT to "http://localhost:3001/articles/1"