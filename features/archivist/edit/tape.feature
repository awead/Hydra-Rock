Feature:
  In order to catalog video content
  As an archivist
  I need to edit the metadata of a tape

  @javascript
  Scenario: Populate fields with autocomplete data via JSON (DAM-214)
    Given I am logged in as "archivist1@example.com"
    And I am on the edit external video page for rockhall:fixture_tape2
    When I fill in "document_fields[format][]" with "Be"
    Then I should see "Betacam"
    And I should see "Betacam SP"
    And I should see "Betacam SX"