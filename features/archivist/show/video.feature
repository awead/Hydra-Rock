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
  