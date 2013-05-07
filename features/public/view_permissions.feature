Feature:
  In order to view items in Hydra
  As a public user
  I should see the permissions of an object

  Scenario: Viewing permissions of an object
    Given I am on the show archival video page for rockhall:fixture_pbcore_document1
    Then I should see the field title "read_access_group_t" contain "Read Access Groups"
    And I should see the field content "read_access_group_t" contain "public"
    And I should see the field content "read_access_group_t" contain "donor"
    And I should see the field title "edit_access_group_t" contain "Edit Access Groups"
    And I should see the field content "edit_access_group_t" contain "archivist"
    And I should see the field content "edit_access_group_t" contain "reviewer"
    And I should see the field title "edit_access_person_t" contain "Edit Access Person"
    And I should see the field content "edit_access_person_t" contain "archivist1@example.com"