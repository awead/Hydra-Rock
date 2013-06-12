Feature: Restricted actions not allowed for the public
  In order to protect assets
  The public
  Should not have access to some features

  Scenario: Disallowed groups should not be able to create archival videos (DAM-163)
    Given I am on the home page
    And I create a new archival video
    Then I should see "Sign in"

  Scenario: Disallowed groups should not see links for asset creation (DAM-163)
    Given I am on the home page
    Then I should not see the "New" dropdown menu