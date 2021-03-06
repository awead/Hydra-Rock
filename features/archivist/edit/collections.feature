@sample
@javascript
Feature:
  In order to link items in Hydra to existing collections
  As an archivist
  I need edit archival collection information for objects

  @wip
  Scenario: Editing archival series and collection
    Given I am logged in as "archivist1@example.com"
    And I am on the collections workflow page for cucumber:1
    Then the "archival_video_collection" field should contain ""
    And the "archival_video_series" field should contain ""
    When I select "Test Collection" from "archival_video_collection"
    And I wait for 5 seconds
    Then the "archival_video_series" field should contain "rockhall:fixture_arc_testref4"
    When I select "Series 1: Sample Series" from "archival_video_series"
    And I press "Save Archival Information"
    Then the "archival_video_collection" field should contain "rockhall:fixture_arc_test"
    And the "archival_video_series" field should contain "rockhall:fixture_arc_testref3"
    And I should see "Video was updated successfully"

  Scenario: Adding additional collections to items
    Given I am logged in as "archivist1@example.com"
    And I am on the collections workflow page for cucumber:1
    When I follow "open_additional_collection_modal"
    And I wait for 2 seconds
    And I fill in "name" with "Foo Collection"
    And I press "add_additional_collection_button"
    And I should see "Video was updated successfully"
    And I close the modal window
    And I wait for 2 seconds
    Then the "additional_collection_0" field should contain "Foo Collection"
    When I follow "delete_additional_collection_0"
    And I wait for 2 seconds
    Then I should not see "Foo Collection"
    And I should see "Video was updated successfully"

  Scenario: Adding accessions to items
    Given I am logged in as "archivist1@example.com"
    And I am on the collections workflow page for cucumber:1
    When I follow "open_accession_modal"
    And I wait for 2 seconds
    And I fill in "name" with "1233456"
    And I press "add_accession_button"
    And I should see "Video was updated successfully"
    And I close the modal window
    And I wait for 2 seconds
    Then the "accession_number_0" field should contain "1233456"
    When I follow "delete_accession_0"
    And I wait for 2 seconds
    Then I should not see "1233456"
    And I should see "Video was updated successfully"

  Scenario: No changes are made
    Given I am logged in as "archivist1@example.com"
    And I am on the collections workflow page for cucumber:1
    When I press "Save Archival Information"
    Then I should see "No changes made"
    When I press "Save Changes"
    Then I should see "No changes made"
