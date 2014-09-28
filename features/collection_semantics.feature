Feature: Collection Semantics
  In order to use the application as a todo list you have to be able
  to add to and remove items from the list and show them.

  Scenario: Adding and receiving a single todo
    Given I added a todo item to 'Pick up milk'
    When I receive all todos
    Then I should receive an item to 'Pick up milk'

  Scenario: Adding two todos at once
    Given I added a todo item to 'Clean the flat' and 'Buy water'
    When I receive all todos
    Then I should receive an item to 'Clean the flat'
    And I should receive an item to 'Buy water'

  Scenario: Format of a todo item
    Given I added a todo item to 'Walk the dog'
    When I receive all todos
    Then I should receive a well formed todo item for 'Walk the dog'

  Scenario: Getting a single item
    Given I added a todo item to 'Clean windows'
    When I follow the link to the item to 'Clean windows'
    Then I should receive a well formed todo item for 'Clean windows'

  Scenario: Deleting a todo item
    Given I added a todo item to 'Do Nothing'
    When I delete a todo item to 'Do Nothing'
    And I receive all todos
    Then I should receive no item to 'Do Nothing'
