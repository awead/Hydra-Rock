Feature:
  In order to find content in the DAM
  As a public user
  I need to browse different facets

  Scenario: Available facets
    Given I am on the home page
    Then I should see facets for:
      | Content Type |
      | Media Format |
      | Name |
      | Subject |
      | Genre |
      | Event/Series |
      | Collection |
      | Language |
      | Review Status |
      | Year |
      | Priority |
      | Depositor |
      | Reviewer |

  Scenario: Facets available from pbcore fixture document1 (DAM-83)
    Given I am on the home page
    Then I should see "Brown, Charles, 1922-1999"
    And I should see "Hunter, Ian, 1939-"
    And I should see "Betacam"
    And I should see "Rock music--History and criticism."
    And I should see "Rock concert films."
    And I should see "Rock and Roll Hall of Fame and Museum. Annual induction ceremony. 1999."
    And I should see "Rock and Roll Hall of Fame and Museum Records. Education and Public Programs Division."

  Scenario: Facet counts
    Given I am on the home page
    Then I should see "Video 3"