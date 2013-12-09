Feature:
  In order to display video content
  As a public user
  I need to view the content of a video

  Scenario: Viewable metadata (DAM-131, DAM-217, DAM-295)
    Given I am on the catalog page for rockhall:fixture_pbcore_document1
    Then I should not see "Tape (1)"
    And I should not see the heading "Videos"
    And I should see the following:
    | id                    | title                 | content |
    | title                 | Main Title            | Rock and Roll Hall of Fame induction ceremony. Part 1. | 
    | alternative_title     | Alternative Title     | [Tape label title] Induction ceremony, line cut reel #20A, 03/15/99. | 
    | summary               | Summary               | (1 of 3) Uncut performances and award presentations from the 1999 ceremony. | 
    | subject               | Subject               | Rock and Roll Hall of Fame and Museum. |
    | subject               | Subject               | Rock music--History and criticism. |
    | subject               | Subject               | Inductee |
    | subject               | Subject               | Rock musicians. | 
    | genre                 | Genre                 | Award presentations (Motion pictures) |
    | genre                 | Genre                 | Rock concert films. | 
    | series                | Event Series          | Rock and Roll Hall of Fame and Museum. Annual induction ceremony. 1999. | 
    | event_place           | Event Place           | New York, NY | 
    | event_date            | Event Date            | 1999-03-15 | 
    | note                  | Note                  | http://rockhall.com/inductees/ceremonies/1999/ | 
    | contributor_name      | Contributor           | Springsteen, Bruce (recipient) |  
    | contributor_name      | Contributor           | McCartney, Paul (recipient) |  
    | contributor_name      | Contributor           | Joel, Billy (recipient) |  
    | contributor_name      | Contributor           | Brown, Charles, 1922-1999 (recipient) |  
    | contributor_name      | Contributor           | Mayfield, Curtis (recipient) |  
    | contributor_name      | Contributor           | Shannon, Del (recipient) |  
    | contributor_name      | Contributor           | Springfield, Dusty (recipient) |  
    | contributor_name      | Contributor           | Staple Singers (recipient) |  
    | contributor_name      | Contributor           | Pickett, Wilson (performer) | 
    | publisher_name        | Publisher             | Rock and Roll Hall of Fame Foundation | 
    | collection            | Archival Collection   | Rock and Roll Hall of Fame Foundation Records |
    | archival_series       | Archival Series       | Series III: Audiovisual materials |
    | additional_collection | Additional Collection | Rock and Roll Hall of Fame and Museum Records. Education and Public Programs Division. | 
    | accession_number      | Accession Number      | LA.2003.01.001 | 
    | depositor             | Depositor             | archivist1@example.com | 
    | reviewer              | Reviewer              | reviewer1@example.com | 
    | license               | License               | Public | 

  Scenario: Message for unavailable video (DAM-200)
    Given I am on the catalog page for rockhall:fixture_pbcore_document1
    Then I should see "Video not available"  

  @wip
  Scenario: Null roles (DAM-169)
    Given I am on the catalog page for rrhof:331
    Then I should see the field content "blacklight-contributor_name_facet" contain "Mastro, James"
    And I should not see "Mastro, James,"
    And I should not see "Mastro, James ()" 

  Scenario: No access to edit workflows from navbar
    Given I am on the catalog page for rockhall:fixture_pbcore_document1
    Then I should not see "Edit" in the navbar
    And I should see "Export" in the navbar

  Scenario: Change Parts List to Contents (DAM-293)
    Given I am on the catalog page for rockhall:fixture_pbcore_document5
    Then I should see the field title "blacklight-contents_ssm" contain "Contents"
