@sample
@javascript
Feature:
  In order to catalog items
  As an archivist
  I should be able to add physical tapes to videos

  Scenario: Adding a tape from the dropdown menu (DAM-282)
    Given I am logged in as "archivist1@example.com"
    And I am on the collections workflow page for cucumber:1
    When I follow "New"
    Then I should see "Tape"
    When I follow "Tape"
    Then I should see "New Tape"

  Scenario: Creating a new tape
    Given I am logged in as "archivist1@example.com"
    And I am on the new tape page for cucumber:1
    When I fill in the following:
      | external_video_date    | 2011-01-11 |
      | external_video_format  | Betacam    |
      | external_video_barcode | 1234567    |
    And I press "Save Changes"
    Then I should see "Tape was successfully created"
    And I should see "Cucumber Sample 1"
    When I follow "Tape (2)"
    Then I should see "2011-01-11"
    And I should see "Betacam"
    And I should see "1234567"

  Scenario: No changes made
    Given I am logged in as "archivist1@example.com"
    And I am on the new tape page for cucumber:1
    When I press "Save Changes"
    Then I should see "No changes made"

  Scenario: Populate fields with autocomplete data via JSON (DAM-214)
    Given I am logged in as "archivist1@example.com"
    And I am on the new tape page for cucumber:1
    When I fill in "external_video_format" with "Be"
    Then I should see "Betacam"
    And I should see "Betacam SP"
    And I should see "Betacam SX"