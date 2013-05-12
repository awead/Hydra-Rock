Feature: Archivist adds new content
  In order to create new digital content for the Rockhall
  As an archivist
  I add new items to the repository

  @javascript
  Scenario: Add archival video (DAM-83)
    Given I am logged in as "archivist1@example.com"
    And I am on the home page
    When I follow "New"
    Then I should see "Archival Video"
    And I should see "Archival Collection"
