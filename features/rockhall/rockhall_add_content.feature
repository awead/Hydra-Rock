Feature: Add rockhall content
  In order to create new digital content for the Rockhall
  As an editor
  I want to see buttons for adding new archival images and videos

  Scenario: Add archival video (DAM-83)
    Given I am logged in as "archivist1@example.com"
    And I am on the home page
    Then I should see "Archival Video"

  Scenario: Disallowed groups should not be able to create assets (DAM-163)
    Given I am logged in as "researcher1@example.com"
    And I am on the home page
    And I create a new archival_video
    Then I should see "You are not allowed to create new content"
    Given I am on the home page
    And I create a new digital_video
    Then I should see "You are not allowed to create new content"

  Scenario: Disallowed groups should not see links for asset creation (DAM-163)
    Given I am on the home page
    Then I should not see "Add a New Asset"
    Given I am logged in as "researcher1@example.com"
    And I am on the home page
    Then I should not see "Add a New Asset"

  Scenario: Allowed groups should be able to create new content (DAM-163)
    Given I am logged in as "reviewer1@example.com"
    And I am on the home page
    Then I should see the "New" dropdown menu
    Given I am logged in as "archivist1@example.com"
    And I am on the home page
    Then I should see the "New" dropdown menu

  Scenario: Reviewers need to add new video objects (DAM-159)
    Given I am logged in as "reviewer1@example.com"
    And I create a new archival_video
    Then I should see "Review Video"
    And I should see "Abstract"
    And the following should be selected within "form#asset_review"
      | priority | normal |
    And the following should be selected within "form#asset_review"
      | complete | no |

  Scenario: Groups can only add certain content types (DAM-164)
    Given I am logged in as "reviewer1@example.com"
    Then I should see "Add archival video"
    And I should not see "Add Generic Content"
    Given I am logged in as "archivist1@example.com"
    Then I should see "Add archival video"
    And I should see "Add Generic Content"