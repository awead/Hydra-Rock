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

  @collections
  Scenario: Importing collections from Blacklight
    Given I am logged in as "archivist1@example.com"
    And I am on the home page
    And I create a new archival_collection
    Then I should see "New Archival Collection"
    When I fill in "archival_collection_pid" with "ARC-0026"
    And I press "Save Changes"
    Then I should see "Doug Fieger Papers"