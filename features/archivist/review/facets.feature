Feature:
  In order to find content for review in Hydra
  As an archivist
  I need to browse different review facets

  Scenario: Review status and 4-digit year facet (DAM-152,154)
    Given I am logged in as "archivist1@example.com"
    Then I should see a facet for "Reviewed"
    And I should see the facet term "yes"
    And I should see a facet for "Creation Date"
    And I should see the facet term "2007"

  Scenario: Priority facet (DAM-155)
    Given I am logged in as "archivist1@example.com"
    Then I should see a facet for "Priority"
    And I should see the facet term "normal"
    And I should see the facet term "high"

  Scenario: Reveiwer facet (DAM-158)
    Given I am logged in as "archivist1@example.com"
    And I am on the home page
    Then I should see a facet for "Reviewer"
    And I should see the facet term "reviewer1@example.com"