Feature:
  In order to prepare existing analog video content for ingestion
  As a library staff user
  I need to catalog the original analog item

  @wip
  Scenario: Create new video object
    Given I am logged in as "archivist1@example.com"
    #Given I am on the base search page
    #When I navigate to "assets/new?content_type=archival_video"
    When I navigate to "catalog/rockhall:fixture_pbcore_document2/edit"
    Then I should see "Content"
    And I should see "Title"
#    And I should see "Language:"
#    And I should see "Summary:"
#    And I should see "Event Location:"
#    And I should see "Event Date"
#    And I should see "Table of Contents"
#    And I should see "Note"
#    And I should see "Carrier"
#    And I should see "Standard"
#    And I should see "Barcode"
#    And I should see "Collection Name"
#    And I should see "Collection Number"
#    And I should see "Accession Number"
#    And I should see a button for "Add contributor"
#    And I should see a button for "Add publisher"
#    And I should see a button for "Add genre"
#    And I should see a button for "Add topic"
#    And I should see "Internal Notes"
#    And I should see "Depositor"
#    And I should see "Submission"
#    And I should see "Access Restrictions"

