Feature:
  In order to display video content
  As a public user
  I need to view the content of a video

  Scenario: Viewable metadata (DAM-131)
    Given I am on the show archival video page for rockhall:fixture_pbcore_document1
    And I should see the field title "main_title_t" contain "Main Title"
    And I should see the field content "main_title_t" contain "Rock and Roll Hall of Fame induction ceremony. Part 1."
    And I should see the field title "alternative_title_t" contain "Alternative Title"
    And I should see the field content "alternative_title_t" contain "[Tape label title] Induction ceremony, line cut reel #20A, 03/15/99."
    And I should see the field title "summary_t" contain "Summary"
    And I should see the field content "summary_t" contain "(1 of 3) Uncut performances and award presentations from the 1999 ceremony."
    And I should see the field title "subjects_t" contain "Subject"
    And I should see the field content "subjects_t" contain "Rock and Roll Hall of Fame and Museum."
    And I should see the field content "subjects_t" contain "Rock music--History and criticism."
    And I should see the field content "subjects_t" contain "Inductee"
    And I should see the field content "subjects_t" contain "Rock musicians."
    And I should see the field title "genres_t" contain "Genre"
    And I should see the field content "genres_t" contain "Award presentations (Motion pictures)"
    And I should see the field content "genres_t" contain "Rock concert films."
    And I should see the field title "event_series_t" contain "Event Series"
    And I should see the field content "event_series_t" contain "Rock and Roll Hall of Fame and Museum. Annual induction ceremony. 1999."
    And I should see the field title "event_place_t" contain "Event Place"
    And I should see the field content "event_place_t" contain "New York, NY"
    And I should see the field title "event_date_t" contain "Event Date"
    And I should see the field content "event_date_t" contain "1999-03-15"
    And I should see the field title "note_t" contain "Note"
    And I should see the field content "note_t" contain "http://rockhall.com/inductees/ceremonies/1999/"
    And I should see the field title "contributors_display" contain "Contributor"
    And I should see the field content "contributors_display" contain "Springsteen, Bruce"
    And I should see the field content "contributors_display" contain "McCartney, Paul"
    And I should see the field content "contributors_display" contain "Joel, Billy"
    And I should see the field content "contributors_display" contain "Brown, Charles, 1922-1999"
    And I should see the field content "contributors_display" contain "Mayfield, Curtis"
    And I should see the field content "contributors_display" contain "Shannon, Del"
    And I should see the field content "contributors_display" contain "Springfield, Dusty"
    And I should see the field content "contributors_display" contain "Staple Singers"
    And I should see the field content "contributors_display" contain "Pickett, Wilson"
    And I should see the field title "publisher_display" contain "Publisher"
    And I should see the field content "publisher_display" contain "Rock and Roll Hall of Fame Foundation"
    And I should see the field title "creation_date_t" contain "Creation Date"
    And I should see the field content "creation_date_t" contain "1999-03-15"
    And I should see the field title "barcode_t" contain "Barcode"
    And I should see the field content "barcode_t" contain "39156042551098"
    And I should see the field title "repository_t" contain "Repository"
    And I should see the field content "repository_t" contain "2809 Woodland Ave."
    And I should see the field title "format_t" contain "Format"
    And I should see the field content "format_t" contain "Betacam"
    And I should see the field title "standard_t" contain "Standard"
    And I should see the field content "standard_t" contain "NTSC"
    And I should see the field title "media_type_t" contain "Media Type"
    And I should see the field content "media_type_t" contain "Moving image"
    And I should see the field title "generation_t" contain "Generation"
    And I should see the field content "generation_t" contain "Original"
    And I should see the field title "language_t" contain "Language"
    And I should see the field content "language_t" contain "eng"
    And I should see the field title "colors_t" contain "Colors"
    And I should see the field content "colors_t" contain "Color"
    And I should see the field title "archival_collection_t" contain "Archival Collection"
    And I should see the field content "archival_collection_t" contain "Rock and Roll Hall of Fame and Museum Records. Education and Public Programs Division."
    And I should see the field title "archival_series_t" contain "Archival Series"
    And I should see the field content "archival_series_t" contain "Audiovisual Materials"
    And I should see the field title "collection_number_t" contain "Collection Number"
    And I should see the field content "collection_number_t" contain "ARC.0002"
    And I should see the field title "accession_number_t" contain "Accession Number"
    And I should see the field content "accession_number_t" contain "LA.2003.01.001"
    And I should see the field title "depositor_t" contain "Depositor"
    And I should see the field content "depositor_t" contain "archivist1@example.com"
    And I should see the field title "reviewer_t" contain "Reviewer"
    And I should see the field content "reviewer_t" contain "reviewer1@example.com"
    And I should see the field title "license_t" contain "License"
    And I should see the field content "license_t" contain "Public"

  Scenario: Message for unavailable video (DAM-200)
    Given I am on the show archival video page for rockhall:fixture_pbcore_document1
    Then I should see "Video not available"
    Given I am logged in as "archivist1@example.com"
    When I am on the edit archival video page for rockhall:fixture_pbcore_document1
    Then I should see "Video not available"

  Scenario: Display video player for digital video objects (DAM-201)
    Given I am on the show archival video page for rockhall:fixture_pbcore_digital_document1
    Then I should see "Part 1"
    Given I am logged in as "archivist1@example.com"
    When I am on the edit archival video page for rockhall:fixture_pbcore_digital_document1
    Then I should see "Part 1"

  Scenario: Video player should be available in edit mode for reviewers (DAM-205)
    Given I am logged in as "reviewer1@example.com"
    When I am on the edit archival video page for rockhall:fixture_pbcore_document2
    Then I should see "Video not available"
    When I am on the edit archival video page for rockhall:fixture_pbcore_digital_document1
    Then I should see "Part 1"
