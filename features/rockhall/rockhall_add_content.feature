Feature: Add rockhall content
  In order to create new digital content for the Rockhall
  As an editor
  I want to see buttons for adding new archival images and videos

  Scenario: Add archival video (DAM-83)
    Given I am logged in as "archivist1@example.com"
    And I am on the home page
    Then I should see "Add archival video"

  Scenario: Login to add archival video (DAM-83)
    Given I am on the home page
    When I follow "Add archival video"
    Then I should see "Sign in"
    And I should see "Email"
    And I should see "Password"



