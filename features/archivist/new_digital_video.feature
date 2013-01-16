Feature:
  In order to prepare born-digital video content for ingestion
  As an archivist
  I need to created a new record for a digital video

  Scenario: Create new digital video object (DAM-169)
    Given I am logged in as "archivist1@example.com"
    And I am on the home page
    And I create a new digital_video
    Then I should see "New Digital Video"
    And I should see "Required Title"
    And I fill in "digital_video[title]" with "Sample Main Title"
    When I press "Save Changes"
    And I should see "Sample Main Title"
    
    # Edit Titles section
    When I follow "Titles"
    Then I should see "Optional Titles"
    And I fill in "document_fields[alternative_title][]" with "Sample Alt Title"
    And I press "+" within "div#additional_alternative_title_clone"
    And I fill in "document_fields[chapter][]" with "Sample Chapter"
    And I fill in "document_fields[episode][]" with "Sample Episode"
    And I fill in "document_fields[title_label][]" with "Sample Label"
    And I fill in "document_fields[segment][]" with "Sample Segment"
    And I fill in "document_fields[subtitle][]" with "Sample Subtitle"
    And I fill in "document_fields[track][]" with "Sample Track"
    And I fill in "document_fields[translation][]" with "Sample Translation"
    And I fill in "document_fields[summary][]" with "Sample summary"
    And I fill in "document_fields[contents][]" with "Sample parts list"
    And I fill in "document_fields[note][]" with "Sample note"
    And I press "Save Changes"
    Then I should see "Required Title"
    
    # Edit Subjects section
    When I follow "Subjects"
    Then I should see "Library of Congress Subject Headings"
    And I fill in "document_fields[lc_subject][]" with "Sample subject"
    And I fill in "document_fields[lc_genre][]" with "Sample genre"
    And I fill in "document_fields[series][]" with "Sample event series"
    And I fill in "document_fields[event_place][]" with "Sample event place"
    And I fill in "document_fields[event_date][]" with "2000-01-01"
    And I press "Save Changes"
    Then I should see "Library of Congress Subject Headings"
    
    # Edit Collection section
    When I follow "Collection"
    Then I should see "Archival Information"
    And I fill in "document_fields[collection][]" with "Sample achival collection"
    And I fill in "document_fields[archival_series][]" with "Sample achival series"
    And I fill in "document_fields[collection_number][]" with "Sample collection number"
    And I fill in "document_fields[accession_number][]" with "Sample accession number"
    And I fill in "document_fields[access][]" with "Sample usage note"
    And I press "Save Changes"

    # Edit Rockhall section
    When I follow "Rockhall"
    Then I should see "Rockhall Fields"
    And I fill in "document_fields[notes][]" with "Sample note"
    And I press "Save Changes"

    # View the entire thing
    When I follow "View"
    Then I should see the following:
      | blacklight-title_display               | Sample Main Title |
      | blacklight-alternative_title_display   | Sample Alt Title |
      | blacklight-chapter_display             | Sample Chapter |
      | blacklight-episode_display             | Sample Episode |
      | blacklight-label_display               | Sample Label |
      | blacklight-segment_display             | Sample Segment |
      | blacklight-subtitle_display            | Sample Subtitle |
      | blacklight-track_display               | Sample Track |
      | blacklight-translation_display         | Sample Translation |
      | blacklight-summary_display             | Sample summary |
      | blacklight-contents_display            | Sample parts list |
      | blacklight-note_display                | Sample note |
      | blacklight-subject_facet               | Sample subject |
      | blacklight-genre_facet                 | Sample genre |
      | blacklight-series_display              | Sample event series |
      | blacklight-event_place_display         | Sample event place |
      | blacklight-event_date_display          | 2000-01-01 |
      | blacklight-collection_facet            | Sample achival collection |
      | blacklight-archival_series_display     | Sample achival series |
      | blacklight-collection_number_display   | Sample collection number |
      | blacklight-accession_number_display    | Sample accession number |
      | blacklight-access_display              | Sample usage note |
      | depositor_facet                        | archivist1@example.com |

  Scenario: Create new digital video object without a title (DAM-210)
    Given I am logged in as "archivist1@example.com"
    And I am on the home page
    And I create a new digital_video
    When I press "Save Changes"
    Then I should see "Main title can't be blank"

  Scenario: Validate correct date format for all date fields (DAM-211)
    Given I am logged in as "archivist1@example.com"
    And I am on the edit digital video page for rockhall:fixture_pbcore_digital_document1
    When I follow "Subjects"
    And I fill in "document_fields[event_date][]" with "bogus date"
    And I press "Save Changes"
    Then I should see "Date must be in YYYY-MM-DD format"

