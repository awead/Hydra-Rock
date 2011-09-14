Feature:
  In order to display video content
  As a public user
  I need to view the content of a video


  Scenario: search for a video
    Given I am on the home page
    And I fill in "q" with "rockhall:fixture_pbcore_document1"
    When I press "search"
    Then I should see a link to "the show document page for rockhall:fixture_pbcore_document1"
    And I should see an icon for video
    And I should see "Rock and Roll Hall of Fame induction ceremony. Part 1."

  Scenario: search for a video barcode
    Given I am on the home page
    And I fill in "q" with "39156042551098"
    When I press "search"
    Then I should see a link to "the show document page for rockhall:fixture_pbcore_document1"
    And I should see an icon for video
    And I should see "Rock and Roll Hall of Fame induction ceremony. Part 1."

  @wip
  Scenario: Viewable metadata
    Given I am on the show document page for rockhall:fixture_pbcore_document1
    Then I should see "Video"
    And I should see the video "rrhof_access_h264_high.avi"
    And I should see the heading "Content"
    And I should see "Title:"
    And I should see "Rock and Roll Hall of Fame induction ceremony. Part 1."
    And I should see "Alt. Title:"
    And I should see "[Tape label title] Induction ceremony, line cut reel #20A, 03/15/99."
    And I should see "Series:"
    And I should see "Rock and Roll Hall of Fame and Museum. Annual induction ceremony. 1999."
    And I should see "Language:"
    And I should see "English"
    And I should see "Summary:"
    And I should see "(1 of 3) Uncut performances and award presentations from the 1999 ceremony."
    And I should see "Event Location:"
    And I should see "New York, NY"
    And I should see "Event Date:"
    And I should see "1999-03-15"
    And I should see "Note:"
    And I should see "http://rockhall.com/inductees/ceremonies/1999/"
    And I should see "Contributor:"
    And I should see "Springsteen, Bruce (recipient)"
    And I should see "McCartney, Paul. (recipient)"
    And I should see "Joel, Billy. (recipient)"
    And I should see "Brown, Charles, 1922-1999. (recipient)"
    And I should see "Mayfield, Curtis. (recipient)"
    And I should see "Shannon, Del. (recipient)"
    And I should see "Springfield, Dusty. (recipient)"
    And I should see "Staple Singers. (recipient)"
    And I should see "Pickett, Wilson (performer)"
    And I should see "Publisher:"
    And I should see "Rock and Roll Hall of Fame Foundation (presenter)"
    And I should see "Entity:"
    And I should see "Rock and Roll Hall of Fame and Museum."
    And I should see "Topic:"
    And I should see "Rock music--History and criticism."
    And I should see "Inductee"
    And I should see "Rock musicians."
    And I should see "Genre:"
    And I should see "Award presentations (Motion pictures)"
    And I should see "Rock concert films."
    And I should see the heading "Original"
    And I should see "Carrier:"
    And I should see "Betacam SP"
    And I should see "Standard:"
    And I should see "NTSC"
    And I should see "Barcode:"
    And I should see "39156042551098"
    And I should see "Collection Name:"
    And I should see "Rock and Roll Hall of Fame and Museum Records. Education and Public Programs Division."
    And I should see "Collection Number:"
    And I should see "ARC.0002"
    And I should see "Accession Number:"
    And I should see "LA.2003.01.001"
    And I should see "Note:"
    And I should see "Testing a note addition"
    And I should see the heading "Rockhall"
    And I should see "Depositor:"
    And I should see "archivist1"
    And I should see the heading "All Files"
    And I should see "access_hq"
    And I should see "access_lq"
    And I should see "preservation"

  Scenario: Videos not ingested yet
    Given I am on the show document page for rockhall:fixture_pbcore_document2
    Then I should see the heading "Content"
    And I should see "Pre-Ingest Video"
    And I should see "This is what a video will look like before it is ingested."
    And I should see the heading "Original"
    And I should see "This is a fake video and no actual original exists."
    And I should not see the heading "Video"
    And I should not see the heading "All Files"
