Feature: Reviewer adds new content
  In order to create new digital content for the Rockhall
  As a reviewer
  I add new items to the repository

  Scenario: Allowed groups should be able to create new content (DAM-163)
    Given I am logged in as "reviewer1@example.com"
    And I am on the home page
    Then I should see the "New" dropdown menu
    And I should see "Archival Video"
    And I should see "Digital Video"

  Scenario: Reviewers need to add new video objects (DAM-159)
    Given I am logged in as "reviewer1@example.com"
    And I create a new archival video
    Then I should see "New Archival Video"
    And I should see "Main title"