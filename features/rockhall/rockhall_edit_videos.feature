Feature:
  In order to catalog video content
  As a library staff user
  I need to edit the metadata of a video

  Scenario: edit video object (DAM-131)
    Given I am logged in as "archivist1@example.com"
    And I am on the edit document page for rockhall:fixture_pbcore_document1
    And I should see "Content"
    And the "main_title" field within "#main_title" should contain "Rock and Roll Hall of Fame induction ceremony. Part 1."
    And I should see "(1 of 3) Uncut performances and award presentations from the 1999 ceremony."
    And the "event_place" field within "#event_place" should contain "New York, NY"
    And the "event_date" field within "#event_date" should contain "1999-03-15"
    And I should see "Set Permissions"
