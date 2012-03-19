Feature: Add rockhall content
  In order to create new digital content for the Rockhall
  As an editor
  I want to see buttons for adding new archival images and videos

  Scenario: Add archival video (DAM-83)
    Given I am logged in as "archivist1@example.com"
    And I am on the home page
    Then I should see "Add archival video"

  Scenario: Disallowed groups should not be able to create assets (BL-163)
    Given I am logged in as "researcher1@example.com"
    And I am on the home page
    And I create a new archival_video
    Then I should see "You are not allowed to create new content"

  Scenario: Disallowed groups should not see links for asset creation (BL-163)
    Given I am on the home page
    Then I should not see "Add a New Asset"
    Given I am logged in as "researcher1@example.com"
    And I am on the home page
    Then I should not see "Add a New Asset"

  Scenario: Allowed groups should be able to create new content (BL-163)
    Given I am logged in as "reviewer1@example.com"
    And I am on the home page
    Then I should see "Add a New Asset"
    Given I am logged in as "archivist1@example.com"
    And I am on the home page
    Then I should see "Add a New Asset"

  Scenario: Reviewers need to add new video objects (BL-159)
    Given I am logged in as "reviewer1@example.com"
    And I create a new archival_video
    Then I should see "Review Video"
    And I should see "Abstract"
    And the following should be selected within "form#asset_review"
      | priority | normal |
    And the following should be selected within "form#asset_review"
      | complete | no |