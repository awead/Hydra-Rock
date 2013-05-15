Feature:
  In order to display video content
  As a public user
  I need to view the content of a video

  Scenario: Viewable metadata (DAM-131)
    Given I am on the catalog page for rockhall:fixture_pbcore_document1
    And I should see the field title "blacklight-title_display" contain "Main Title"
    And I should see the field content "blacklight-title_display" contain "Rock and Roll Hall of Fame induction ceremony. Part 1."
    And I should see the field title "blacklight-alternative_title_display" contain "Alternative Title"
    And I should see the field content "blacklight-alternative_title_display" contain "[Tape label title] Induction ceremony, line cut reel #20A, 03/15/99."
    And I should see the field title "blacklight-summary_display" contain "Summary"
    And I should see the field content "blacklight-summary_display" contain "(1 of 3) Uncut performances and award presentations from the 1999 ceremony."
    And I should see the field title "blacklight-subject_facet" contain "Subject"
    And I should see the field content "blacklight-subject_facet" contain "Rock and Roll Hall of Fame and Museum."
    And I should see the field content "blacklight-subject_facet" contain "Rock music--History and criticism."
    And I should see the field content "blacklight-subject_facet" contain "Inductee"
    And I should see the field content "blacklight-subject_facet" contain "Rock musicians."
    And I should see the field title "blacklight-genre_facet" contain "Genre"
    And I should see the field content "blacklight-genre_facet" contain "Award presentations (Motion pictures)"
    And I should see the field content "blacklight-genre_facet" contain "Rock concert films."
    And I should see the field title "blacklight-series_display" contain "Event Series"
    And I should see the field content "blacklight-series_display" contain "Rock and Roll Hall of Fame and Museum. Annual induction ceremony. 1999."
    And I should see the field title "blacklight-event_place_display" contain "Event Place"
    And I should see the field content "blacklight-event_place_display" contain "New York, NY"
    And I should see the field title "blacklight-event_date_display" contain "Event Date"
    And I should see the field content "blacklight-event_date_display" contain "1999-03-15"
    And I should see the field title "blacklight-note_display" contain "Note"
    And I should see the field content "blacklight-note_display" contain "http://rockhall.com/inductees/ceremonies/1999/"
    And I should see the field title "blacklight-contributor_name_facet" contain "Contributor"
    And I should see the field content "blacklight-contributor_name_facet" contain "Springsteen, Bruce"
    And I should see the field content "blacklight-contributor_name_facet" contain "McCartney, Paul"
    And I should see the field content "blacklight-contributor_name_facet" contain "Joel, Billy"
    And I should see the field content "blacklight-contributor_name_facet" contain "Brown, Charles, 1922-1999"
    And I should see the field content "blacklight-contributor_name_facet" contain "Mayfield, Curtis"
    And I should see the field content "blacklight-contributor_name_facet" contain "Shannon, Del"
    And I should see the field content "blacklight-contributor_name_facet" contain "Springfield, Dusty"
    And I should see the field content "blacklight-contributor_name_facet" contain "Staple Singers"
    And I should see the field content "blacklight-contributor_name_facet" contain "Pickett, Wilson"
    And I should see the field title "blacklight-publisher_name_facet" contain "Publisher"
    And I should see the field content "blacklight-publisher_name_facet" contain "Rock and Roll Hall of Fame Foundation"
    And I should see the field title "blacklight-collection_facet" contain "Archival Collection"
    And I should see the field content "blacklight-collection_facet" contain "Rock and Roll Hall of Fame and Museum Records. Education and Public Programs Division."
    And I should see the field title "blacklight-archival_series_display" contain "Archival Series"
    And I should see the field content "blacklight-archival_series_display" contain "Series 1: Sample Series"
    And I should see the field title "blacklight-collection_number_display" contain "Collection Number"
    And I should see the field content "blacklight-collection_number_display" contain "rockhall-fixture_arc_test"
    And I should see the field title "blacklight-accession_number_display" contain "Accession Number"
    And I should see the field content "blacklight-accession_number_display" contain "LA.2003.01.001"
    And I should see the field title "depositor_facet" contain "Depositor"
    And I should see the field content "depositor_facet" contain "archivist1@example.com"
    And I should see the field title "reviewer_facet" contain "Reviewer"
    And I should see the field content "reviewer_facet" contain "reviewer1@example.com"
    And I should see the field title "license_display" contain "License"
    And I should see the field content "license_display" contain "Public"

  Scenario: Message for unavailable video (DAM-200)
    Given I am on the catalog page for rockhall:fixture_pbcore_document1
    Then I should see "Video not available"  

  Scenario: Displaying role terms in view mode (DAM-217)
    Given I am on the catalog page for rockhall:fixture_pbcore_document1
    Then I should see the field content "blacklight-contributor_name_facet" contain "Springsteen, Bruce (recipient)"

  Scenario: Null roles (DAM-169)
    Given I am on the catalog page for rrhof:331
    Then I should see the field content "blacklight-contributor_name_facet" contain "Mastro, James"
    And I should not see "Mastro, James,"
    And I should not see "Mastro, James ()"  
