Feature:
  In order to view items in Hydra
  As an archivist
  I need to see the permissions of an object

  Scenario: Viewing permissions of an object
    Given I am logged in as "archivist1@example.com"
    And I am on the show archival video page for rockhall:fixture_pbcore_document1
    Then I should see the field title "read_access_group_t" contain "Read Access Groups"
    And I should see the field content "read_access_group_t" contain "Public"
    And I should see the field content "read_access_group_t" contain "Rockhall Staff"
    And I should see the field title "edit_access_group_t" contain "Edit Access Groups"
    And I should see the field content "edit_access_group_t" contain "Library Staff"
    And I should see the field title "edit_access_person_t" contain "Edit Access Person"
    And I should see the field content "edit_access_person_t" contain "archivist1@example.com"