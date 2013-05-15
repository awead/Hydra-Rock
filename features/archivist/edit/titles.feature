Feature:
  In order to edit items in Hydra
  As an archivist
  I need add and edit titles

  Scenario: Change Title Label to Label (DAM-266)
    Given I am logged in as "archivist1@example.com"
    And I am on the titles workflow page for rrhof:525
    Then I should not see the field label "archival_video_title_label" contain "Title label"
    And I should see the field label "archival_video_label" contain "Label"

  @sample
  @javascript
  Scenario: Editing fields in the description workflow
    Given I am logged in as "archivist1@example.com"
    And I am on the titles workflow page for cucumber:1
    And I fill in "alternative_title_0" with "alternative_title_0"
    And I fill in "chapter_0" with "chapter_0"
    And I fill in "episode_0" with "episode_0"
    And I fill in "title_label_0" with "title_label_0"
    And I fill in "segment_0" with "segment_0"
    And I fill in "subtitle_0" with "subtitle_0"
    And I fill in "track_0" with "track_0"
    And I fill in "translation_0" with "translation_0"
    When I press "Save Changes"
    Then the "alternative_title_0" field should contain "alternative_title_0"
    And the "chapter_0" field should contain "chapter_0"
    And the "episode_0" field should contain "episode_0"
    And the "title_label_0" field should contain "title_label_0"
    And the "segment_0" field should contain "segment_0"
    And the "subtitle_0" field should contain "subtitle_0"
    And the "track_0" field should contain "track_0"
    And the "translation_0" field should contain "translation_0"
    And I should see "Video was updated successfully"

  @sample
  @javascript
  Scenario: No changes are made
    Given I am logged in as "archivist1@example.com"
    And I am on the titles workflow page for cucumber:1
    When I press "Save Changes"
    Then I should see "No changes made"


