Feature:
  In order to view items in Hydra
  As an archivist
  I need to see the permissions of an object

  Scenario: Viewing permissions of an object
    Given I am logged in as "archivist1@example.com"
    And I am on the show archival video page for rockhall:fixture_pbcore_document1
    Then I should see the "group" "read" permissions field title contain "Read Access Groups"
    And I should see the "group" "read" permissions field content contain "Public"
    And I should see the "group" "read" permissions field content contain "Rockhall Staff"
    And I should see the "group" "edit" permissions field title contain "Edit Access Groups"
    And I should see the "group" "edit" permissions field content contain "Library Staff"
    And I should see the "individual" "edit" permissions field title contain "Edit Access Person"
    And I should see the "individual" "edit" permissions field content contain "archivist1@example.com"