Feature:
  In order to prepare existing analog or digital video content for ingestion
  As a archivist
  I need to create a new record for the video

  Scenario: Create new archival video object (DAM-169)
    Given I am logged in as "archivist1@example.com"
    And I am on the home page
    And I create a new archival video
    Then I should see "New Archival Video"
    And I should see "Main title"
    And I should see "Required Title"
    When I fill in "archival_video[title]" with "Sample Main Title"
    And I press "Save Changes"
    Then I should see "Sample Main Title"

  Scenario: Create new archival video object without a title (DAM-210)
    Given I am logged in as "archivist1@example.com"
    And I am on the home page
    And I create a new archival video
    When I press "Save Changes"
    Then I should see "Main title can't be blank"
