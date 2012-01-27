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

  @wip
  Scenario: Review status and 4-digit year facet
    Given I am logged in as "reviewer1@example.com"
    Then I should see "Status"
    And I should see "yes"
    And I should see "no"
    And I should see "Creation Date"
    And I should see "2007"