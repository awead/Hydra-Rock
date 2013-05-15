Feature:
  In order to view items in Hydra
  As an archivist
  I need to view information about the object

  Scenario: Navbar access
    Given I am logged in as "archivist1@example.com"
    And I am on the catalog page for rockhall:fixture_pbcore_document1
    Then I should see "Edit" in the navbar
    And I should see "Pbcore" in the navbar
    And I should see "New" in the navbar
  
  @javascript
  Scenario: Accessing edit features from the show view
    Given I am logged in as "archivist1@example.com"
    And I am on the catalog page for rrhof:525
    When I follow "Edit"
    Then I should see "Titles" in the navbar
    And I should see "Subjects" in the navbar
    And I should see "Copy: preservation" in the navbar
    And I should see "Copy: access" in the navbar
    And I should see "Original" in the navbar
