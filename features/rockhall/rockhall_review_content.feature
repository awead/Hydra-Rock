Feature:
  In order to control who has access to what content
  As a reviewer
  I need to apply the correct kind of license to an object


Description:
  Videos and other digital assets that are ingested in to Hydra may need to be reviewed by
  members of the Museum staff to determine what level of access is required or available.
  Hydra should allow these users to specify these access levels and indicate whether or not
  these objects have been reviewed.

  @wip
  Scenario: Reviewer logs in and checks the status of an item (DAM-123)
    Given I am logged in as "archivist1@example.com"
    And I am on the show document page for rockhall:fixture_pbcore_document3
    Then I should see "Review Information"
    And I should see "Reviewer"
    And I should see "reviewer1@example.com"
    And I should see "Date Completed"
    And I should see "2011-11-22"
    And I should see "Date Updated"
    And I should see "2011-11-22"
    And I should see "License"
    And I should see "Rockhall"
    And I should see "Notes"
    And I should see "We don't have permission to show this to the public"

  Scenario: Reviewer edits the status of an item (DAM-123)
    Given I am logged in as "reviewer1@example.com"
    And I am on the edit page for rockhall:fixture_pbcore_document3
    Then I should see "Review This Item"
    And I should not see "Content"
    And I should not see "Delete Fields"
    And I should not see "Original"
    And I should not see "Add Fields"
    And I should not see "Digital Files"
    And I should not see "Rockhall Metadata"
    And I should not see "Set Permissions"