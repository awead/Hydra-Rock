Feature:
  In order to prepare existing analog or digital video content for ingestion
  As a archivist
  I need to create a new record for the video

  Scenario: Create new archival video object (DAM-169)
    Given I am logged in as "archivist1@example.com"
    And I am on the home page
    And I create a new archival video
    And I should see "Required Title"
    And I fill in "archival_video[title]" with "Sample Main Title"
    When I press "Save Changes"
    Then I should see "Sample Main Title"

    # Edit Titles section
    When I follow "Titles"
    Then I should see "Optional Titles"
    And I fill in "document_fields[alternative_title][]" with "Sample Alt Title"
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
    And I fill in "document_fields[event_date][]" with "2010-02-03"
    And I press "Save Changes"
    Then I should see "Library of Congress Subject Headings"
    
    # Edit Original section
    When I follow "Original"
    Then I should see "Original Item"
    And the "archival_video_repository" field should contain "Rock and Roll Hall of Fame and Museum"
    And I select "Color" from "archival_video_colors"
    And I select "NTSC" from "archival_video_standard"
    And I fill in the following:
      | archival_video_creation_date | 2010-02-03                |
      | archival_video_barcode       | Sample barcode            |
      | archival_video_media_format  | Sample format             |
      | archival_video_generation    | Original                  |
      | archival_video_language      | eng                       |
      | collection_0                 | Sample achival collection |
      | archival_series_0            | Sample achival series     |
      | collection_number_0          | Sample collection number  |
      | accession_number_0           | Sample accession number   |
      | access_0                     | Sample usage note         |
      | condition_note_0             | Sample condition note     |
      | cleaning_note_0              | Sample cleaning note      |
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
      | blacklight-event_date_display          | 2010-02-03 |
      | blacklight-creation_date_display       | 2010-02-03 |
      | blacklight-barcode_display             | Sample barcode |
      | blacklight-repository_display          | Rock and Roll Hall of Fame and Museum |
      | blacklight-media_format_facet          | Sample format |
      | blacklight-standard_display            | NTSC |
      | blacklight-media_type_display          | Moving image |
      | blacklight-generation_display          | Original |
      | blacklight-language_display            | eng |
      | blacklight-colors_display              | Color |
      | blacklight-collection_facet            | Sample achival collection |
      | blacklight-archival_series_display     | Sample achival series |
      | blacklight-collection_number_display   | Sample collection number |
      | blacklight-accession_number_display    | Sample accession number |
      | blacklight-access_display              | Sample usage note |
      | blacklight-condition_note_display      | Sample condition note |
      | blacklight-cleaning_note_display       | Sample cleaning note |
      | depositor_facet                        | archivist1@example.com |

  Scenario: Create new digital video object without a title (DAM-210)
    Given I am logged in as "archivist1@example.com"
    And I am on the home page
    And I create a new archival video
    When I press "Save Changes"
    Then I should see "Main title can't be blank"

  Scenario: Validate correct date format for all date fields (DAM-211)
    Given I am logged in as "archivist1@example.com"
    And I am on the edit digital video page for rockhall:fixture_pbcore_document1
    When I follow "Subjects"
    And I fill in "document_fields[event_date][]" with "bogus date"
    And I press "Save Changes"
    Then I should see "Date must be in YYYY-MM-DD format"
    When I follow "Original"
    And I fill in "document_fields[creation_date][]" with "bogus"
    And I press "Save Changes"
    Then I should see "Date must be in YYYY-MM-DD format"

  Scenario: Partial dates in solr (DAM-212)
    Given I am logged in as "archivist1@example.com"
    And I am on the home page
    And I create a new archival video
    And I should see "Required Title"
    And I fill in "archival_video[title]" with "Sample Main Title"
    When I press "Save Changes"
    Then I should see "Sample Main Title"
    When I follow "Subjects"
    And I fill in "document_fields[event_date][]" with "1999"
    And I press "Save Changes"
    Then the "event_date_0" field should contain "1999"
    And I fill in "document_fields[event_date][]" with "2003-12"
    And I press "Save Changes"
    Then the "event_date_0" field should contain "2003-12"
    When I follow "Original"
    And I fill in "document_fields[creation_date][]" with "1999"
    And I press "Save Changes"
    Then the "archival_video_creation_date" field should contain "1999"
    And I fill in "document_fields[creation_date][]" with "2003-12"
    And I press "Save Changes"
    Then the "archival_video_creation_date" field should contain "2003-12"
