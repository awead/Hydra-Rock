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