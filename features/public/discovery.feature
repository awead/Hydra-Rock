Feature: Public disovery of resources
  In order to allow gated discovery of specific assets
  As a public user
  I should see content in search result listsing, but not be able to view it

  Scenario: Seeing 'discover only' content in search results (DAM-318)
    Given I am on the home page
    And I fill in "q" with "Ian Hunter"
    When I press "Search"
    Then I should see "Evening with series. Ian Hunter. Part 1."
    And I should see "Evening with series. Ian Hunter. Part 2."

  Scenario: Prevent item-level view on discover-only content (DAM-318)
    Given I am on the catalog page for rrhof:525
    Then I should see "You do not have sufficient access privileges to read this document, which has been marked private."