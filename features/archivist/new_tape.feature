@sample
@javascript
Feature:
  In order to catalog items
  As an archivist
  I should be able to add physical tapes to videos

  Scenario: Adding a tape from the dropdown menu (DAM-282)
    Given I am logged in as "archivist1@example.com"
    And I am on the collections workflow page for cucumber:1
    When I follow "New"
    Then I should see "Tape"
