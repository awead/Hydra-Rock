Feature:
  In order to edit items in Hydra
  As an archivist
  I need to navigate to different parts of the workflow

  Scenario: Edit path should default to the titles workflow step
    Given I am logged in as "archivist1@example.com"
    Given I am on the edit archival video page for rockhall:fixture_pbcore_document1
    Then I should see "Required Title"  

  @javascript
  Scenario: Navigating different parts of the workflow (DAM-169)
    Given I am logged in as "archivist1@example.com"
    Given I am on the titles workflow page for rockhall:fixture_pbcore_document1
    Then I should see "Required Title"
    When I follow "Edit"
    And I follow "Descriptions"
    Then I should see "Description"
    When I follow "Edit"
    And I follow "Subjects"
    Then I should see "Library of Congress Subject Headings"
    When I follow "Edit"
    And I follow "Persons"
    Then I should see "Contributors"
    When I follow "Edit"
    And I follow "Collections"
    Then I should see "Archival Information"
    When I follow "Edit"
    And I follow "Permissions"
    Then I should see "Group Permissions"