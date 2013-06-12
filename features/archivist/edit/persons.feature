@sample
@javascript
Feature:
  In order to edit items in Hydra
  As an archivist
  I need add and edit persons such as contributors and publishers

  Scenario: Add a new nodes enter information (DAM-169)
    Given I am logged in as "archivist1@example.com"
    And I am on the persons workflow page for cucumber:1
    And I follow "open_contributor_modal"
    And I wait for 2 seconds
    And I fill in "name" with "John Doe"
    And I select "performer" from "role"
    And I press "add_contributor_button"
    And I should see "Video was updated successfully"
    And I close the modal window
    And I wait for 2 seconds
    Then the "contributor_name_0" field should contain "John Doe"
    And the "contributor_role_0" field should contain "performer"
    When I follow "delete_contributor_0"
    Then I should not see "John Doe"
    And I should see "Video was updated successfully"
    And I follow "open_publisher_modal"
    And I wait for 2 seconds
    And I fill in "name" with "Jane Doe"
    And I select "presenter" from "role"
    And I press "add_publisher_button"
    And I should see "Video was updated successfully"
    And I close the modal window
    And I wait for 2 seconds    
    Then the "publisher_name_0" field should contain "Jane Doe"
    And the "publisher_role_0" field should contain "presenter"
    When I follow "delete_publisher_0"
    Then I should not see "Jane Doe"
    And I wait for 2 seconds
    And I should see "Video was updated successfully"

  Scenario: It should not update an object if no persons are present (DAM-286)
    Given I am logged in as "archivist1@example.com"
    And I am on the persons workflow page for cucumber:1
    When I press "Save Changes"
    Then I should not see "Video was updated successfully"
    And I should see "No changes made"

  Scenario: It should not update an object if persons are present (DAM-286)
    Given I am logged in as "archivist1@example.com"
    And I am on the persons workflow page for rockhall:fixture_pbcore_document1
    When I press "Save Changes"
    Then I should not see "Video was updated successfully"
    And I should see "No changes made"

  @multiple-persons
  Scenario: Deleting indivual persons (DAM-310)
    Given I am logged in as "archivist1@example.com"
    And I am on the persons workflow page for cucumber:1
    Then the "contributor_name_0" field should contain "John"
    And the "contributor_name_1" field should contain "Paul"
    And the "contributor_name_2" field should contain "George"
    And the "contributor_name_3" field should contain "Ringo"
    When I follow "delete_contributor_0"
    Then I should not see "John"
    And the "contributor_name_0" field should contain "Paul"
    And the "contributor_name_1" field should contain "George"
    And the "contributor_name_2" field should contain "Ringo"
    When I follow "delete_contributor_1"
    Then I should not see "George"
    And the "contributor_name_0" field should contain "Paul"
    And the "contributor_name_1" field should contain "Ringo"


