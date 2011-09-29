Feature:
  In order to catalog video content
  As a library staff user
  I need to edit the metadata of a video

  Scenario: edit video object (DAM-83)
    Given I am logged in as "archivist1@example.com"
    And I am on the edit document page for rockhall:fixture_pbcore_document1
    And I should see "Content"
    And I should see "Rock and Roll Hall of Fame induction ceremony. Part 1."
    And I should see "English"
    And I should see "(1 of 3) Uncut performances and award presentations from the 1999 ceremony."
    And I should see "New York, NY"
    And I should see "1999-03-15"
    And I should see "http://rockhall.com/inductees/ceremonies/1999/"
    And I should see "original"
    And I should see "h264"
    And I should see "Rockhall"
    And I should see "Set Permissions"

