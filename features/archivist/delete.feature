Feature:
  In order to manage items in Hydra
  As an archivist
  I need to delete videos

  @javascript
  Scenario: Delete a video I just created
    Given I am logged in as "archivist1@example.com"
    And I am on the home page
    And I follow "New"
    And I follow "Archival Video"
    When I fill in "archival_video_title" with "Cucumber Delete Video"
    And I press "Save Changes"
    Then I should see "Video was successfully created."
    When I follow "Edit"
    And I follow "Delete"
    And I acccept the alert
    And I wait for 2 seconds
    Then I should see "Deleted"
