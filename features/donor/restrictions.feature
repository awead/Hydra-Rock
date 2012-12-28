Feature: Retricted actions not allowed for donors
  In order to protect assets
  Donors
  Should have limited access to some features

  Scenario: Disallowed groups should not be able to create archival videos (DAM-163)
    Given I am logged in as "donor1@example.com"
    And I am on the home page
    And I create a new archival video
    Then I should see "You are not allowed to create new content"
    And I create a new digital_video
    Then I should see "You are not allowed to create new content"

  Scenario: Disallowed groups should not see links for asset creation (DAM-163)
    Given I am logged in as "donor1@example.com"
    And I am on the home page
    Then I should not see the "New" dropdown menu