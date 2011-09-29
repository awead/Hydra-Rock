Feature:
  In order to prepare existing analog video content for ingestion
  As a library staff user
  I need to catalog the original analog item

  Scenario: Create new video object (DAM-83)
    Given I am logged in as "archivist1@example.com"
    And I am on the home page
    And I create a new archival_video
    Then I should see "Content"
    And I should see "Title"
    And I should see "Language"
    And I should see "Summary"
    And I should see "Event Location"
    And I should see "Event Date"
    And I should see "Table of Contents"
    And I should see "Note"
    And I should see "Carrier"
    And I should see "Standard"
    And I should see "Barcode"
    And I should see "Collection Name"
    And I should see "Collection Number"
    And I should see "Accession Number"
    And I should see a "Add contributor" button
    And I should see a "Add publisher" button
    And I should see a "Add genre" button
    And I should see a "Add topic" button
    And I should see "Internal Notes"
    And I should see "Depositor"
    And I should see "Submission"
    And I should see "Access Restrictions"

