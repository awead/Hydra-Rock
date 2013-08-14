@sample
@javascript
Feature:
  In order to review a video
  As a an archivist
  I need to edit the fields in the review workflow

Description:
  Videos and other digital assets that are ingested in to Hydra may need to be reviewed by
  members of the Museum staff to determine what level of access is required or available.
  Hydra should allow these users to specify these access levels and indicate whether or not
  these objects have been reviewed.

  Scenario: Reviewer edits the status of an item (DAM-123)
    Given I am logged in as "archivist1@example.com"
    And I am on the review workflow page for cucumber:1
    When I select "no" from "document_fields_complete"
    And I select "low" from "document_fields_priority"
    And I select "Publicly Available" from "document_fields_license"
    And I fill in "archival_video_abstract" with "Sample abstract"
    And I press "Save Changes"
    Then I should see "Video was updated successfully"
    And the "document_fields_complete" field should contain "no"
    And the "document_fields_priority" field should contain "low"
    And the "document_fields_license" field should contain "Publicly Available"
    And the "archival_video_abstract" field should contain "Sample abstract"

  Scenario: Reviewer metdata getting wiped out (DAM-148)
    Given I am logged in as "archivist1@example.com"
    And I am on the titles workflow page for cucumber:1
    And I fill in "document_fields[alternative_title][]" with "Fake alt title"
    And I press "Save Changes"
    When I follow "View"
    Then I should see "Fake alt title"
    And I should see the field title "reviewer_ssm" contain "Reviewer"
    And I should see the field content "reviewer_ssm" contain "reviewer1@example.com"
    And I should see the field title "abstract_ssm" contain "Abstract"
    And I should see the field content "abstract_ssm" contain "We don't have permission to show this to the public"