Feature:
  In order to catalog video content
  As a library staff user
  I need to edit the metadata of a video

  @javascript
  Scenario: edit video object (DAM-131)
    Given I am logged in as "archivist1@example.com"
    Given I am on the edit archival video page for rockhall:fixture_pbcore_document1
    Then I should see "Required Title"
    And the "archival_video_title" field should contain "Rock and Roll Hall of Fame induction ceremony. Part 1."
    And the "alternative_title_0" field should contain "\[Tape label title\] Induction ceremony, line cut reel \#20A, 03\/15\/99."
    And the "summary" field should contain "\(1 of 3\) Uncut performances and award presentations from the 1999 ceremony."
    And the "note_0" field should contain "http\:\/\/rockhall\.com\/inductees\/ceremonies\/1999\/"
    When I press "Save Changes"
    Then I should see "Required Title"
    When I follow "Subjects"
    Then I should see "Library of Congress Subject Headings"
    And the "lc_subject_0" field should contain "Rock music--History and criticism."
    And the "lc_subject_1" field should contain "Rock and Roll Hall of Fame and Museum."
    And the "lc_subject_2" field should contain "Inductee"
    And the "lc_subject_3" field should contain "Rock musicians."
    And I should see "LCGFT"
    And the "lc_genre_0" field should contain "Award presentations \(Motion pictures\)"
    And the "lc_genre_1" field should contain "Rock concert films."
    And I should see "Event Fields"
    And the "series_0" field should contain "Rock and Roll Hall of Fame and Museum\. Annual induction ceremony\. 1999\."
    And the "event_place_0" field should contain "New York, NY"
    And the "event_date_0" field should contain "1999-03-15"
    When I press "Save Changes"
    Then I should see "Library of Congress Subject Headings"
    When I follow "Persons"
    Then I should see "Contributors"
    And the "contributor_name_0" field should contain "Springsteen, Bruce"
    And the "contributor_role_0" field should contain "recipient"
    And I should see "Publishers"
    And the "publisher_name_0" field should contain "Rock and Roll Hall of Fame Foundation"
    And the "publisher_role_0" field should contain "presenter"
    When I follow "Original"
    Then I should see "Original Item"
    And the "archival_video_creation_date" field should contain "1999-03-15"
    And the "archival_video_barcode" field should contain "39156042551098"
    And I should see "Archival Information"
    And the "collection_0" field should contain "Rock and Roll Hall of Fame and Museum Records. Education and Public Programs Division."
    When I follow "Rockhall"
    Then I should see "Rockhall Fields"
    When I follow "Permissions"
    Then I should see "Group Permissions"

  Scenario: Edit path should default to the titles workflow step
    Given I am logged in as "archivist1@example.com"
    Given I am on the edit archival video page for rockhall:fixture_pbcore_document1
    Then I should see "Required Title"       

  @javascript
  Scenario: Navigating different parts of the workflow (DAM-169)
    Given I am logged in as "archivist1@example.com"
    Given I am on the titles workflow page for rockhall:fixture_pbcore_document1
    Then I should see "Required Title"
    When I follow "Edit"
    And I follow "Descriptions"
    Then I should see "Description"
    When I follow "Edit"
    And I follow "Subjects"
    Then I should see "Library of Congress Subject Headings"
    When I follow "Edit"
    And I follow "Persons"
    Then I should see "Contributors"
    When I follow "Edit"
    And I follow "Collections"
    Then I should see "Archival Information"
    When I follow "Edit"
    And I follow "Permissions"
    Then I should see "Group Permissions"
