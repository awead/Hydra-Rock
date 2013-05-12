@javascript
Feature:
  In order to catalog video content
  As an archivist
  I need to edit the metadata of a tape

  Scenario: Populate fields with autocomplete data via JSON (DAM-214)
    Given I am logged in as "archivist1@example.com"
    And I am on the edit external video page for rockhall:fixture_tape2
    When I fill in "document_fields[format][]" with "Be"
    Then I should see "Betacam"
    And I should see "Betacam SP"
    And I should see "Betacam SX"

  Scenario: No changes are made
    Given I am logged in as "archivist1@example.com"
    And I am on the edit external video page for rockhall:fixture_tape2
    When I press "Save Changes"
    Then I should see "No changes made"

  @sample
  Scenario: Edting tape fields
    Given I am logged in as "archivist1@example.com"
    And I am on the edit external video page for cucumber:2
    When I fill in the following:
      | external_video_date | 2001-01-12 |
      | external_video_format | external_video_format |
      | external_video_barcode  | external_video_barcode |
      | external_video_language | external_video_language |
      | external_video_rights_summary | external_video_rights_summary |
      | external_video_condition | external_video_condition |
      | external_video_cleaning | external_video_cleaning |
    And I select "NTSC" from "external_video_standard"
    And I press "Save Changes"
    Then I should see the following in edit fields:
      | external_video_date | 2001-01-12 |
      | external_video_format | external_video_format |
      | external_video_barcode  | external_video_barcode |
      | external_video_language | external_video_language |
      | external_video_rights_summary | external_video_rights_summary |
      | external_video_condition | external_video_condition |
      | external_video_cleaning | external_video_cleaning |
      | external_video_standard | NTSC |
      | external_video_generation | Original |
      | external_video_colors | Color |
      | external_video_location | Rock and Roll Hall of Fame and Museum, |
    And I should see "Video was updated successfully"
