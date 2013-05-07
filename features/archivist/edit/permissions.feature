@sample
@javascript
Feature:
  In order to edit items in Hydra
  As an archivist
  I need edit the permissions for an object

  Scenario: Default group permissions should be selected
    Given I am logged in as "archivist1@example.com"
    And I am on the permissions workflow page for cucumber:1
    Then the "document_fields_permissions_groups_archivist" field should contain "edit"
    And the "document_fields_permissions_groups_donor" field should contain "read"
    And the "document_fields_permissions_groups_reviewer" field should contain "edit"
    And the "document_fields_permissions_groups_public" field should contain "none"

  Scenario: Change group permssions
    Given I am logged in as "archivist1@example.com"
    And I am on the permissions workflow page for cucumber:1
    When I select "Read/Download" from "document_fields_permissions_groups_public"
    And I select "No Access" from "document_fields_permissions_groups_donor"
    And I press "Save Changes"
    Then I should see "Permissions updated successfully"
    And the "document_fields_permissions_groups_donor" field should contain "none"
    And the "document_fields_permissions_groups_reviewer" field should contain "edit"
    And the "document_fields_permissions_groups_public" field should contain "read"
    And the "document_fields_permissions_groups_archivist" field should contain "edit"