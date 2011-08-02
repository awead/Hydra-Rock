Feature: Add rockhall content
  In order to create new digital content for the Rockhall
  As an editor
  I want to see buttons for adding new archival images and videos

  Scenario:
    Given I am logged in as "archivist1"
    Given I am on the base search page
    Then I should see "Add an archival image" within "div#create-asset-box"
    And I should see "Add archival video" within "div#create-asset-box"

  Scenario:
    Given I am on the base search page
    Then I should not see "Add an archival image"
    And I should not see "Add archival video"

  Scenario:
    Given I am logged in as "archivist1"
    Given I am on the base search page
    Then I should be able to create an asset of content type "archival_image"
    And I should be able to create an asset of content type "archival_video"


