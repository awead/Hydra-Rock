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
    Given I am logged in as "archivist1@example.com"
    And I am on the show archival video page for rockhall:fixture_pbcore_document3
    And I should see the field title "reviewer_t" contain "Reviewer"
    And I should see the field content "reviewer_t" contain "reviewer1@example.com"
    And I should see the field title "complete_t" contain "Complete"
    And I should see the field content "complete_t" contain "yes"
    And I should see the field title "date_updated_t" contain "Date Updated"
    And I should see the field content "date_updated_t" contain "2011-11-29"
    And I should see the field title "license_t" contain "License"
    And I should see the field content "license_t" contain "Rockhall Use Only"
    And I should see the field title "abstract_t" contain "Abstract"
    And I should see the field content "abstract_t" contain "We don't have permission to show this to the public"
    And I should see the field title "priority_t" contain "Priority"
    And I should see the field content "priority_t" contain "high"

  Scenario: Reviewer edits the status of an item (DAM-123)
    Given I am logged in as "reviewer1@example.com"
    And I am on the review document page for rockhall:fixture_pbcore_document3
    Then I should see "License"
    And I should see "We don't have permission to show this to the public."
    And the following should be selected within "fieldset#reviewer_fields"
      | document_fields_complete | yes |
      | document_fields_priority | high |
      | document_fields_license | Rockhall Use Only |
    When I select the following within "fieldset#reviewer_fields"
      | document_fields_complete | no |
      | document_fields_priority | low |
      | document_fields_license | Publicly Available |
    And I press "Save Changes"
    Then the following should be selected within "fieldset#reviewer_fields"
      | document_fields_license | no |
      | document_fields_priority | low |
      | document_fields_license | Publicly Available |

  Scenario: User who is not a reviewer should not be able to review an item (DAM-123)
    Given I am logged in as "archivist1@example.com"
    And I am on the review document page for rockhall:fixture_pbcore_document3
    Then I should see "You are not allowed to review this document"

  Scenario: Reviewers should be redirected to the edit reivew page (DAM-123)
    Given I am logged in as "reviewer1@example.com"
    And I am on the edit archival video page for rockhall:fixture_pbcore_document3
    Then I should see "You have been redirected to the review page for this document"

  Scenario: Reviewer metdata getting wiped out (DAM-148)
    Given I am logged in as "archivist1@example.com"
    And I am on the edit archival video page for rockhall:fixture_pbcore_document3
    And I fill in "document_fields[alternative_title][]" with "Fake alt title"
    And I press "Save Changes"
    And I follow "Original"
    And I fill in "document_fields[condition_note][]" with "Fake note"
    And I press "Save Changes"
    When I follow "View"
    Then I should see "Fake alt title"
    And I should see "Fake note"
    And I should see the field title "reviewer_t" contain "Reviewer"
    And I should see the field content "reviewer_t" contain "reviewer1@example.com"
    And I should see the field title "abstract_t" contain "Abstract"
    And I should see the field content "abstract_t" contain "We don't have permission to show this to the public"

  Scenario: Searching the abstract field (DAM-151)
    Given I am logged in as "reviewer1@example.com"
    When I fill in "q" with "Old Time Rock"
    And I press "Search"
    Then I should see "Hall of Fame Series. An evening with Little Richard. Pt. 1."

  Scenario: Searching title field (DAM-157)
    Given I am logged in as "reviewer1@example.com"
    And I am on the home page
    When I fill in "q" with "An evening with Little Richard"
    And I press "Search"
    Then I should see "Hall of Fame Series. An evening with Little Richard. Pt. 1."
    Given I am on the home page
    When I fill in "q" with "Little Richard"
    And I press "Search"
    Then I should see "Hall of Fame Series. An evening with Little Richard. Pt. 1."



