Feature:
  In order to display video content
  As a public user
  I need to view the content of a video

  Scenario: search for a video (DAM-83)
    Given I am on the home page
    And I fill in "q" with "rockhall:fixture_pbcore_document1"
    When I press "submit"
    Then I should see a link to "the show document page for rockhall:fixture_pbcore_document1"
    And I should see "Rock and Roll Hall of Fame induction ceremony. Part 1."

  Scenario: search for a video barcode (DAM-83)
    Given I am on the home page
    And I fill in "q" with "39156042551098"
    When I press "submit"
    Then I should see a link to "the show document page for rockhall:fixture_pbcore_document1"
    And I should see "Rock and Roll Hall of Fame induction ceremony. Part 1."

  Scenario: Viewable metadata (DAM-131)
    Given I am on the show document page for rockhall:fixture_pbcore_document1
    And I should see the heading "Content"
    And I should see the field title "main_title" contain "Main Title"
    And I should see the field content "main_title" contain "Rock and Roll Hall of Fame induction ceremony. Part 1."
    And I should see the field title "alternative_title" contain "Alternative Title"
    And I should see the field content "alternative_title" contain "[Tape label title] Induction ceremony, line cut reel #20A, 03/15/99."
    And I should see the field title "summary" contain "Summary"
    And I should see the field content "summary" contain "(1 of 3) Uncut performances and award presentations from the 1999 ceremony."
    And I should see the field title "subjects" contain "Subjects"
    And I should see the field content "subjects" contain "Rock and Roll Hall of Fame and Museum."
    And I should see the field content "subjects" contain "Rock music--History and criticism."
    And I should see the field content "subjects" contain "Inductee"
    And I should see the field content "subjects" contain "Rock musicians."
    And I should see the field title "genres" contain "Genres"
    And I should see the field content "genres" contain "Award presentations (Motion pictures)"
    And I should see the field content "genres" contain "Rock concert films."
    And I should see the field title "event_series" contain "Event Series"
    And I should see the field content "event_series" contain "Rock and Roll Hall of Fame and Museum. Annual induction ceremony. 1999."
    And I should see the field title "event_place" contain "Event Place"
    And I should see the field content "event_place" contain "New York, NY"
    And I should see the field title "event_date" contain "Event Date"
    And I should see the field content "event_date" contain "1999-03-15"
    And I should see the field title "note" contain "Note"
    And I should see the field content "note" contain "http://rockhall.com/inductees/ceremonies/1999/"
    And I should see the field title "contributor" contain "Contributor"
    And I should see the field content "contributor" contain "Springsteen, Bruce"
    And I should see the field content "contributor" contain "McCartney, Paul"
    And I should see the field content "contributor" contain "Joel, Billy"
    And I should see the field content "contributor" contain "Brown, Charles, 1922-1999"
    And I should see the field content "contributor" contain "Mayfield, Curtis"
    And I should see the field content "contributor" contain "Shannon, Del"
    And I should see the field content "contributor" contain "Springfield, Dusty"
    And I should see the field content "contributor" contain "Staple Singers"
    And I should see the field content "contributor" contain "Pickett, Wilson"
    And I should see the field title "publisher" contain "Publisher"
    And I should see the field content "publisher" contain "Rock and Roll Hall of Fame Foundation"
    And I should see the heading "Original"
    And I should see the field title "creation_date" contain "Creation Date"
    And I should see the field content "creation_date" contain "1999-03-15"
    And I should see the field title "barcode" contain "Barcode"
    And I should see the field content "barcode" contain "39156042551098"
    And I should see the field title "repository" contain "Repository"
    And I should see the field content "repository" contain "2809 Woodland Ave."
    And I should see the field title "format" contain "Format"
    And I should see the field content "format" contain "Betacam"
    And I should see the field title "standard" contain "Standard"
    And I should see the field content "standard" contain "NTSC"
    And I should see the field title "media_type" contain "Media Type"
    And I should see the field content "media_type" contain "Moving image"
    And I should see the field title "generation" contain "Generation"
    And I should see the field content "generation" contain "Original"
    And I should see the field title "language" contain "Language"
    And I should see the field content "language" contain "eng"
    And I should see the field title "colors" contain "Colors"
    And I should see the field content "colors" contain "Color"
    And I should see the field title "archival_collection" contain "Archival Collection"
    And I should see the field content "archival_collection" contain "Rock and Roll Hall of Fame and Museum Records. Education and Public Programs Division."
    And I should see the field title "archival_series" contain "Archival Series"
    And I should see the field content "archival_series" contain "Audiovisual Materials"
    And I should see the field title "collection_number" contain "Collection Number"
    And I should see the field content "collection_number" contain "ARC.0002"
    And I should see the field title "accession_number" contain "Accession Number"
    And I should see the field content "accession_number" contain "LA.2003.01.001"
    And I should see the heading "Rockhall"
    And I should see the field title "depositor" contain "Depositor"
    And I should see the field content "depositor" contain "archivist1@example.com"
    And I should see the heading "Review Information"
    And I should see the field title "reviewer" contain "Reviewer"
    And I should see the field content "reviewer" contain "reviewer1@example.com"
    And I should see the field title "license" contain "License"
    And I should see the field content "license" contain "Public"
