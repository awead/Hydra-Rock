@javascript
Feature:
  In order to fill out information properly for new items
  As an archivist
  I should only be allowed to enter correct dates

  @sample
  Scenario: Dates on new tapes
    Given I am logged in as "archivist1@example.com"
    And I am on the new tape page for cucumber:1
    When I fill in "external_video_date" with "bad dates"
    And I press "Save Changes"
    Then I should see "Date must be in YYYY-MM-DD format"  