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
    And I am on the show document page for rockhall:fixture_pbcore_document3
    Then I should see the heading "Review Information"
    And I should see the field title "reviewer" contain "Reviewer"
    And I should see the field content "reviewer" contain "reviewer1@example.com"
    And I should see the field title "complete" contain "Complete"
    And I should see the field content "complete" contain "yes"
    And I should see the field title "date_updated" contain "Date Updated"
    And I should see the field content "date_updated" contain "2011-11-29"
    And I should see the field title "license" contain "License"
    And I should see the field content "license" contain "Rockhall Use Only"
    And I should see the field title "abstract" contain "Abstract"
    And I should see the field content "abstract" contain "We don't have permission to show this to the public"

  Scenario: Reviewer edits the status of an item (DAM-123)
    Given I am logged in as "reviewer1@example.com"
    And I am on the review document page for rockhall:fixture_pbcore_document3
    Then I should see "License"
    And the following should be selected within "form#asset_review"
      | license | Rockhall Use Only |
    And I should see "We don't have permission to show this to the public."
    And the following should be selected within "form#asset_review"
      | complete | yes |
    When I select the following within "form#asset_review"
      | license | Publicaly Available |
    And I select the following within "form#asset_review"
      | complete | no |
    And I press "Submit Review"
    Then I should see the field content "complete" contain "no"
    And I should see the field content "license" contain "Publicaly Available"
    And I should see the field content "date_updated" contain the current date

  Scenario: User who is not a reviewer should not be able to review an item (DAM-123)
    Given I am logged in as "archivist1@example.com"
    And I am on the review document page for rockhall:fixture_pbcore_document3
    Then I should see "You are not allowed to review this document"

  Scenario: Reviewers should be redirected to the edit reivew page (DAM-123)
    Given I am logged in as "reviewer1@example.com"
    And I am on the edit document page for rockhall:fixture_pbcore_document3
    Then I should see "You have been redirected to the review page for this document"

  Scenario: Reviewer metdata getting wiped out (DAM-148)
    Given I am logged in as "archivist1@example.com"
    And I am on the edit document page for rockhall:fixture_pbcore_document3
    And I fill in "asset[descMetadata][alternative_title][0]" with "Fake alt title"
    And I press "Save Document"
    And I fill in "asset[descMetadata][condition_note][0]" with "Fake note"
    And I press "Save Original"
    When I follow "Switch to browse view"
    Then I should see "Fake alt title"
    And I should see "Fake note"
    And I should see the field title "reviewer" contain "Reviewer"
    And I should see the field content "reviewer" contain "reviewer1@example.com"
    And I should see the field title "abstract" contain "Abstract"
    And I should see the field content "abstract" contain "We don't have permission to show this to the public"




