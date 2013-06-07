Feature:
  In order to find videos that need work
  As an archivist
  I need to search for videos

  Scenario: Searching the abstract field (DAM-151)
    Given I am logged in as "archivist1@example.com"
    When I fill in "q" with "Old Time Rock"
    And I press "Search"
    Then I should see "Hall of Fame Series. An evening with Little Richard. Pt. 1."

  # This has been changed to use a title search
  Scenario: Searching title field (DAM-157)
    Given I am logged in as "archivist1@example.com"
    And I am on the home page
    When I fill in "q" with "An evening with Little Richard"
    And I choose a title search
    And I press "Search"
    Then I should see "Hall of Fame Series. An evening with Little Richard. Pt. 1."

  Scenario: Searching title field, part 2 (DAM-157)
    Given I am logged in as "archivist1@example.com"
    And I am on the home page
    When I fill in "q" with "Little Richard"
    And I press "Search"
    Then I should see "Hall of Fame Series. An evening with Little Richard. Pt. 1."