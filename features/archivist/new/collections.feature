@javascript
Feature:
  In order to link items in Hydra to existing collections
  As an archivist
  I need import archival collections from Archivists Toolkit

  Scenario: No id entered
    Given I am logged in as "archivist1@example.com"
    And I am on the new archival collections page
    When I press "Save Changes"
    And I wait for 2 seconds
    Then I should see "No changes made"

  Scenario: ID not found in the discovery index
    Given I am logged in as "archivist1@example.com"
    And I am on the new archival collections page
    When I fill in "archival_collection_pid" with "FOO"
    And I press "Save Changes"
    And I wait for 2 seconds
    Then I should see "ID FOO not found in discovery index"

  @collections
  Scenario: Importing collections from Blacklight
    Given I am logged in as "archivist1@example.com"
    And I am on the new archival collections page
    Then I should see "New Archival Collection"
    When I fill in "archival_collection_pid" with "ARC-0026"
    And I press "Save Changes"
    Then I should see "Doug Fieger Papers"