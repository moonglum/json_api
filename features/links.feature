Feature: Links
  In order to have hypermedia, we have to be able to connect entities
  with one another and then get information about which entities an
  entity is connected to.

  Scenario: Adding an assignee to an todo item should be reflected on the item
    Given I added a todo item to 'Read a book'
    And I created a person 'Lucas'
    And I assign the todo 'Read a book' to 'Lucas'
    When I follow the link to the item to 'Read a book'
    Then it should have the assignee 'Lucas'

  Scenario: Adding an assignee to an todo item should be reflected on the assignee
    Given I added a todo item to 'Go fish'
    And I created a person 'Dirk'
    And I assign the todo 'Go fish' to 'Dirk'
    When I follow the link to the user 'Dirk'
    Then he should have an assigned task 'Go fish'
