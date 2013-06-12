Feature:
  In order to review a video
  As a an archivist
  I need to view the fields in the review workflow

  Scenario: Check the status of an item (DAM-123)
    Given I am logged in as "archivist1@example.com"
    And I am on the catalog page for rockhall:fixture_pbcore_document3
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
