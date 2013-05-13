Feature:
  In order to link items in Hydra to existing collections
  As an archivist
  I need import archival collections from Archivists Toolkit

  Scenario: Faceting on existing collections
    Given I am on the home page
    When I follow "Collection"
    Then I should see "Test Collection"

  Scenario: Displaying collections
    Given I am on the show document page for rockhall:fixture_arc_test
    Then I should see "Test Collection"
    And I should see "Items in Collection"