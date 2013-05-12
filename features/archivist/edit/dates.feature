@javascript
Feature:
  In order to fill out information properly
  As an archivist
  I should only be allowed to enter correct dates

  @sample
  Scenario: Adding new event dates should require the correct format
    Given I am logged in as "archivist1@example.com"
    And I am on the subjects workflow page for cucumber:1
    When I follow "open_event_modal"
    And I wait for 2 seconds
    And I select "Event Date" from "event_type"
    And I fill in "event_value" with "Wrong Date"
    And I press "add_event_button"
    Then I should see "Event date Date must be in YYYY-MM-DD format"

  Scenario: Editing existing event dates
    Given I am logged in as "archivist1@example.com"
    And I am on the subjects workflow page for rrhof:331
    When I fill in "event_date_0" with "bad dates"
    And I press "Save Changes"
    Then should see "Date must be in YYYY-MM-DD format"

  Scenario: Editing dates on tapes
    Given I am logged in as "archivist1@example.com"
    And I am on the edit external video page for rockhall:fixture_tape2
    When I fill in "external_video_date" with "foo date"
    And I press "Save Changes"
    Then should see "Date must be in YYYY-MM-DD format"

  @sample
  Scenario: Partial dates in solr (DAM-212)
    Given I am logged in as "archivist1@example.com"
    And I am on the edit external video page for cucumber:2  
    When I fill in "external_video_date" with "1999"
    And I press "Save Changes"
    Then the "external_video_date" field should contain "1999"
    When I fill in "external_video_date" with "2003-12"
    And I press "Save Changes"
    Then the "external_video_date" field should contain "2003-12"