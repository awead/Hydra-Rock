Feature:
  In order to display video content
  As a public user
  I need to view the content of a video

  Scenario: Viewable metadata (DAM-131, DAM-217, DAM-295)
    Given I am on the catalog page for rockhall:fixture_pbcore_document1
    Then I should not see "Tape (1)"
    And I should not see the heading "Videos"
    And I should see the following:
    | id                                   | title               | content |
    | blacklight-title_display             | Main Title          | Rock and Roll Hall of Fame induction ceremony. Part 1. | 
    | blacklight-alternative_title_display | Alternative Title   | [Tape label title] Induction ceremony, line cut reel #20A, 03/15/99. | 
    | blacklight-summary_display           | Summary             | (1 of 3) Uncut performances and award presentations from the 1999 ceremony. | 
    | blacklight-subject_facet             | Subject             | Rock and Roll Hall of Fame and Museum. |
    | blacklight-subject_facet             | Subject             | Rock music--History and criticism. |
    | blacklight-subject_facet             | Subject             | Inductee |
    | blacklight-subject_facet             | Subject             | Rock musicians. | 
    | blacklight-genre_facet               | Genre               | Award presentations (Motion pictures) |
    | blacklight-genre_facet               | Genre               | Rock concert films. | 
    | blacklight-series_display            | Event Series        | Rock and Roll Hall of Fame and Museum. Annual induction ceremony. 1999. | 
    | blacklight-event_place_display       | Event Place         | New York, NY | 
    | blacklight-event_date_display        | Event Date          | 1999-03-15 | 
    | blacklight-note_display              | Note                | http://rockhall.com/inductees/ceremonies/1999/ | 
    | blacklight-contributor_name_facet    | Contributor         | Springsteen, Bruce (recipient) |  
    | blacklight-contributor_name_facet    | Contributor         | McCartney, Paul (recipient) |  
    | blacklight-contributor_name_facet    | Contributor         | Joel, Billy (recipient) |  
    | blacklight-contributor_name_facet    | Contributor         | Brown, Charles, 1922-1999 (recipient) |  
    | blacklight-contributor_name_facet    | Contributor         | Mayfield, Curtis (recipient) |  
    | blacklight-contributor_name_facet    | Contributor         | Shannon, Del (recipient) |  
    | blacklight-contributor_name_facet    | Contributor         | Springfield, Dusty (recipient) |  
    | blacklight-contributor_name_facet    | Contributor         | Staple Singers (recipient) |  
    | blacklight-contributor_name_facet    | Contributor         | Pickett, Wilson (performer) | 
    | blacklight-publisher_name_facet      | Publisher           | Rock and Roll Hall of Fame Foundation | 
    | blacklight-collection_facet          | Archival Collection | Test Collection |
    | blacklight-collection_facet          | Archival Collection | Rock and Roll Hall of Fame and Museum Records. Education and Public Programs Division. | 
    | blacklight-archival_series_display   | Archival Series     | Series 1: Sample Series | 
    | blacklight-collection_number_display | Collection Number   | rockhall-fixture_arc_test | 
    | blacklight-accession_number_display  | Accession Number    | LA.2003.01.001 | 
    | depositor_facet                      | Depositor           | archivist1@example.com | 
    | reviewer_facet                       | Reviewer            | reviewer1@example.com | 
    | license_display                      | License             | Public | 

  Scenario: Message for unavailable video (DAM-200)
    Given I am on the catalog page for rockhall:fixture_pbcore_document1
    Then I should see "Video not available"  

  Scenario: Null roles (DAM-169)
    Given I am on the catalog page for rockhall:fixture_pbcore_document1
    Then I should see the field content "blacklight-publisher_name_facet" contain "Rock and Roll Hall of Fame Foundation"
    And I should not see "Rock and Roll Hall of Fame Foundation,"
    And I should not see "Rock and Roll Hall of Fame Foundation ()" 

  Scenario: No access to edit workflows from navbar
    Given I am on the catalog page for rockhall:fixture_pbcore_document1
    Then I should not see "Edit" in the navbar
    And I should see "Export" in the navbar

  Scenario: Change Parts List to Contents (DAM-293)
    Given I am on the catalog page for rockhall:fixture_pbcore_digital_document1
    Then I should see the field title "blacklight-contents_display" contain "Contents"
