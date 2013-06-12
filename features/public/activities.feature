Feature:
  In order to see what's been happening in Hydra
  As a public user
  I should see the activities feed

  Scenario: View the feed on the home page
    Given I am on the home page
    Then I should see "deleted the video Bad Video"
    And I should see "created a new video, Bad Video, but it has since been deleted"
    And I should see "created a new video"
    And I should see "Evening with series. Ian Hunter. Part 2."

  Scenario: See all the activities
    Given I am not logged in
    And I am on the activities page
    Then I should see "deleted the video Bad Video"
    And I should see "created a new video, Bad Video, but it has since been deleted"
    And I should see "created a new video"
    And I should see "Evening with series. Ian Hunter. Part 2."

  Scenario: See all the activities for a paricular user
    Given I am not logged in
    And I am on the activities page for user 1
    Then I should see "deleted the video Bad Video"
    And I should see "created a new video, Bad Video, but it has since been deleted"
    And I should see "created a new video"
    And I should see "Evening with series. Ian Hunter. Part 2."