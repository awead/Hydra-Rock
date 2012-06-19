@javascript
Feature: Displaying technical metadata from video files
  In order to see all the relevant technical data from a video file
  As as archivist
  I should be able to view combined information from the relevant datastreams

Narrative:
  Technical metadata from pbcore and mediaInfo datastreams needs to be combined for display.

  Scenario: File size information should come from mediaInfo xml (DAM-202)
    Given I am logged in as "archivist1@example.com"
    When I am on the show archival video page for rockhall:fixture_pbcore_document3
    And I follow "Original (1)"
    Then I should see "80.2 GiB"

  Scenario: Digital video sips have no tech data in pbcore and needs to come from mediaInfo
    Given I am logged in as "archivist1@example.com"
    When I am on the show digital video page for rockhall:fixture_pbcore_digital_document1
    And I follow "Original (1)"
    Then I should see "143 GiB"
    And I should see "4:2:2"