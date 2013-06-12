Feature:
  In order view information in Hydra
  As an archivist
  I need view the metadata for our items

  Scenario: Displaying collections
    Given I am on the catalog page for rockhall:fixture_arc_test
    Then I should see "Test Collection"
    And I should see "Items in Collection"
    And I should see "Oral History Example"
    And I should see "Hall of Fame Series"