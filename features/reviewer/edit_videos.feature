Feature:
  In order to review videos
  As a reviewer
  I need to edit information about videos

  @wip
  Scenario: Video player should be available in edit mode for reviewers (DAM-205)
    Given I am logged in as "reviewer1@example.com"
    When I am on the edit archival video page for rockhall:fixture_pbcore_document2
    Then I should see "Video not available"