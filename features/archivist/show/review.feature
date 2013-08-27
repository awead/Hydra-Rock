Feature:
  In order to review a video
  As a an archivist
  I need to view the fields in the review workflow

  Scenario: Check the status of an item (DAM-123)
    Given I am logged in as "archivist1@example.com"
    And I am on the catalog page for rockhall:fixture_pbcore_document3
    And I should see the following:
    | id       | title    | content |
    | reviewer | Reviewer | reviewer1@example.com |
    | complete | Complete | yes |
    | license  | License  | Rockhall Use Only |
    | abstract | Abstract | We don't have permission to show this to the public |
    | priority | Priority | high |