Feature:
  In order to find content in the DAM
  As a public user
  I need to browse different facets

  Scenario: Facets available from pbcore fixture document1 (DAM-83)
    Given I am on the home page
    Then I should see "Springsteen, Bruce"
    And I should see "Joel, Billy"
    And I should see "Rock music--History and criticism."
    And I should see "Rock concert films."
    And I should see "Rock and Roll Hall of Fame and Museum. Annual induction ceremony. 1999."
    And I should see "Rock and Roll Hall of Fame and Museum Records. Education and Public Programs Division."

  Scenario: Review status and 4-digit year facet (DAM-152,154)
    Given I am logged in as "reviewer1@example.com"
    Then I should see a facet for "Status"
    And I should see the facet term "yes"
    And I should see the facet term "no"
    And I should see a facet for "Year"
    And I should see the facet term "2007"

  Scenario: "Publication Year" Facet Rename (DAM-153)
    Given I am on the home page
    Then I should see a facet for "Year"
    And I should not see a facet for "Publication Year"

  Scenario: Priority facet (DAM-155)
    Given I am logged in as "reviewer1@example.com"
    Then I should see a facet for "Priority"
    And I should see the facet term "normal"
    And I should see the facet term "high"
