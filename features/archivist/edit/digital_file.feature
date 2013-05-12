@javascript
Feature:
  In order to catalog video content
  As an archivist
  I need to edit the metadata for a digital file

  @sample
  Scenario: Edit the fields in a digital file
    Given I am logged in as "archivist1@example.com"
    And I am on the edit external video page for cucumber:3
    When I fill in the following:
      | rights_summary_0 | rights summary |
      | note_0           | note           |
    And I press "Save Changes"
    Then I should see the following in edit fields:
      | rights_summary_0 | rights summary |
      | note_0           | note           |
    And I should see "Video was updated successfully"

  Scenario: No changes made
    Given I am logged in as "archivist1@example.com"
    And I am on the edit external video page for rockhall:fixture_pbcore_document3_original
    When I press "Save Changes"
    Then I should see "No changes made"