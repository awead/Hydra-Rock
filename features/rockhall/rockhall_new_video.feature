Feature:
  In order to prepare existing analog video content for ingestion
  As a library staff user
  I need to catalog the original analog item

  Scenario: Create new video object (DAM-128)
    Given I am logged in as "archivist1@example.com"
    And I am on the home page
    And I create a new archival_video
    Then I should see "Content"
    And I should see "Main Title"
    And I should see "Alternative Title"
    And I should see "Chapter"
    And I should see "Episode"
    And I should see "Label"
    And I should see "Segment"
    And I should see "Subtitle"
    And I should see "Track"
    And I should see "Translation"
    And I should see "Summary"
    And I should see "Parts List"
    And I should see "Subject"
    And I should see "Genre"
    And I should see "Event Series"
    And I should see "Event Place"
    And I should see "Event Date"
    And I should see "Note"
    And I should see a "Save Document" button
    And I should see "Original"
    And I should see "Creation Date"
    And I should see "Repository"
    And I should see "Rock and Roll Hall of Fame and Museum"
    And I should see "Format"
    And I should see "Standard"
    And I should see "Media Type"
    And the "media_type" field within "#media_type" should contain "Moving image"
    And I should see "Generation"
    And the "generation" field within "#generation" should contain "Original"
    And I should see "Colors"
    And the "colors" field within "#colors" should contain "Color"
    And I should see "Archival Collection"
    And I should see "Archival Series"
    And I should see "Collection Number"
    And I should see "Accession Number"
    And I should see "Usage"
    And I should see "Condition Note"
    And I should see "Cleaning Note"
    And I should see a "Save Original" button
    And I should see a "Add contributor" button
    And I should see a "Add publisher" button
    And I should see "Rockhall Metadata"
    And I should see "Internal Notes"
    And I should see "Depositor"
    And I should see "Submission"
    And I should see "Access Restrictions"
    And I should see a "Save Description" button
    And the following should be selected within "form#asset_review"
      | priority | normal |

