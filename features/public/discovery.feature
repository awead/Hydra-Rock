Feature:
  When I view items that are listed as discoverable
  As a public user
  I should have restricted access

  Scenario: Searching for discoverable items
    Given I am on the home page
    And I fill in "q" with "Evening series"
    When I press "Search"
    Then I should see "Evening with series. Ian Hunter. Part 2."
    And I should see "Evening with series. Ian Hunter. Part 1."

  Scenario: Viewing discoverable items
    Given I am on the catalog page for rrhof:331
    Then I should see "You do not have sufficient access privileges to read this document, which has been marked private."  