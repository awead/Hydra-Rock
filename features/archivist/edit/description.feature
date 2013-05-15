@sample
@javascript
Feature:
  In order to edit items in Hydra
  As an archivist
  I need add and edit descriptions

  Scenario: Editing fields in the description workflow
    Given I am logged in as "archivist1@example.com"
    And I am on the descriptions workflow page for cucumber:1
    And I fill in "summary" with "Foo summary"
    And I fill in "contents" with "Bar contents"
    And I fill in "note_0" with "Baz note"
    When I press "Save Changes"
    Then the "summary" field should contain "Foo summary"
    And the "contents" field should contain "Bar contents"
    And the "note_0" field should contain "Baz note"
    And I should see "Video was updated successfully"

  Scenario: No changes are made
    Given I am logged in as "archivist1@example.com"
    And I am on the descriptions workflow page for cucumber:1
    When I press "Save Changes"
    Then I should see "No changes made" 

  Scenario: Change Parts List to Contents (DAM-293)
    Given I am logged in as "archivist1@example.com"
    And I am on the descriptions workflow page for cucumber:1
    Then I should see the field label "archival_video_contents" contain "Contents"