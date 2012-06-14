Feature:
  In order to see the technical details of the video files
  As a registerd user
  I need to see the technical metadata associated with a video file

  @javascript
  Scenario: Clicking on the file heading reveals a table of fields
    Given I am logged in as "archivist1@example.com"
    When I am on the show archival video page for rockhall:fixture_pbcore_document3
    And I follow "Original"
    Then I should see "39156042439369_preservation.mov"
    And I should see "Copy: preservation"
    And I follow "H264"
    Then I should see "39156042439369_access.mp4"
    And I should see "Copy: access"
