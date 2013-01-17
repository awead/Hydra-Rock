Feature:
  In order to control who has access to what content
  As a reviewer
  I need to apply the correct kind of license to an object

Description:
  Videos and other digital assets that are ingested in to Hydra may need to be reviewed by
  members of the Museum staff to determine what level of access is required or available.
  Hydra should allow these users to specify these access levels and indicate whether or not
  these objects have been reviewed.

  Scenario: Reviewer logs in and checks the status of an item (DAM-123)
    Given I am logged in as "reviewer1@example.com"
    And I am on the show archival video page for rockhall:fixture_pbcore_document3
    And I should see the field title "reviewer_facet" contain "Reviewer"
    And I should see the field content "reviewer_facet" contain "reviewer1@example.com"
    And I should see the field title "complete_facet" contain "Complete"
    And I should see the field content "complete_facet" contain "yes"
    And I should see the field title "license_display" contain "License"
    And I should see the field content "license_display" contain "Rockhall Use Only"
    And I should see the field title "abstract_display" contain "Abstract"
    And I should see the field content "abstract_display" contain "We don't have permission to show this to the public"
    And I should see the field title "priority_facet" contain "Priority"
    And I should see the field content "priority_facet" contain "high"

  Scenario: Reviewer edits the status of an item (DAM-123)
    Given I am logged in as "reviewer1@example.com"
    And I am on the review document page for rockhall:fixture_pbcore_document3
    Then I should see "License"
    And I should see "We don't have permission to show this to the public."
    And the "document_fields_complete" field should contain "yes"
    And the "document_fields_priority" field should contain "high"
    And the "document_fields_license" field should contain "Rockhall Use Only"
    When I select "no" from "document_fields_complete"
    And I select "low" from "document_fields_priority"
    And I select "Publicly Available" from "document_fields_license"
    And I press "Save Changes"
    Then the "document_fields_complete" field should contain "no"
    And the "document_fields_priority" field should contain "low"
    And the "document_fields_license" field should contain "Publicly Available"
    When I select "yes" from "document_fields_complete"
    And I select "high" from "document_fields_priority"
    And I select "Rockhall Use Only" from "document_fields_license"
    And I press "Save Changes"
    Then I should see "License"
    And I should see "We don't have permission to show this to the public."
    And the "document_fields_complete" field should contain "yes"
    And the "document_fields_priority" field should contain "high"
    And the "document_fields_license" field should contain "Rockhall Use Only"

  Scenario: Reviewers should be redirected to the edit reivew page (DAM-123)
    Given I am logged in as "reviewer1@example.com"
    And I am on the edit archival video page for rockhall:fixture_pbcore_document3
    Then I should see "You have been redirected to the review page for this document"

   Scenario: Reviewer metdata getting wiped out (DAM-148)
    Given I am logged in as "archivist1@example.com"
    And I am on the edit archival video page for rockhall:fixture_pbcore_document3
    And I fill in "document_fields[alternative_title][]" with "Fake alt title"
    And I press "Save Changes"
    When I follow "View"
    Then I should see "Fake alt title"
    And I should see the field title "reviewer_facet" contain "Reviewer"
    And I should see the field content "reviewer_facet" contain "reviewer1@example.com"
    And I should see the field title "abstract_display" contain "Abstract"
    And I should see the field content "abstract_display" contain "We don't have permission to show this to the public"