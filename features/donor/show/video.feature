Feature:
  In order to display video content
  As a donor
  I need to view the content of a video

  Scenario: Viewable metadata (DAM-131)
    Given I am logged in as "donor1@example.com"
    And I am on the catalog page for rockhall:fixture_pbcore_document1
    Then I should see the heading "Videos"
    And I should see "Original (1)"

  Scenario: No access to edit workflows from navbar
    Given I am logged in as "donor1@example.com"
    And I am on the catalog page for rockhall:fixture_pbcore_document1
    Then I should not see "Edit" in the navbar
    And I should see "Export" in the navbar