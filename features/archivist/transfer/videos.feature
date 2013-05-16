Feature:
  In order to group videos together in Hydra
  As an archivist
  I need transfer tapes and files from one video to another

  Narrative: 
    Physical videos are usually one record with a single tape and multiple files.  Sometimes a
    single event will comprise multiple tapes, and is cataloged with multiple records.If we want to
    combine these tapes in to one descriptive record, we need to combine tapes from one record to
    another.

  @sample
  Scenario: Importing tapes from a non-existent record
    Given I am logged in as "archivist1@example.com"
    And I am on the import page for cucumber:1
    And I fill in "source" with "foo"
    When I press "Transfer"
    Then I should see "Source foo does not exist"
  
  @sample
  Scenario: Blank entry
    Given I am logged in as "archivist1@example.com"
    And I am on the import page for cucumber:1
    When I press "Transfer"
    Then I should see "Please enter a source pid"

  @import
  @javascript
  Scenario: Importing from another video
    Given I am logged in as "archivist1@example.com"
    And I am on the titles workflow page for cucumber:1
    And I follow "New"
    And I follow "import_video_modal"
    And I wait for 2 seconds
    And I fill in "source" with "cucumber:2"
    When I press "Transfer"
    And I wait for 2 seconds
    And I acccept the alert
    And I wait for 5 seconds
    Then I should see "Videos were transferred successfully"
    When I close the modal window
    Then I should see "Tape (1)"
    And I should see "Tape (2)"
    And I should see the heading "Videos"

  @javascript
  Scenario: Reloading video list shows heading when there aren't any videos
    Given I am logged in as "archivist1@example.com"
    And I am on the titles workflow page for rockhall:fixture_pbcore_document4
    And I follow "New"
    And I follow "import_video_modal"
    And I wait for 2 seconds
    When I close the modal window
    And I wait for 4 seconds
    Then I should not see the heading "Videos"

