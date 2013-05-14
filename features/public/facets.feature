Feature:
  In order to find content in Hydra
  As a public user
  I need to browse different facets

  Scenario: Available facets
    Given I am on the home page
    Then I should see facets for:
      | Media Type |
      | Name |
      | Subject |
      | Genre |
      | Event/Series |
      | Reviewed |
      | Priority |
      | Depositor |
      | Reviewer |

  Scenario: Facets available from pbcore fixture document1 (DAM-83)
    Given I am on the home page
    Then I should see "Brown, Charles, 1922-1999"
    And I should see "Hunter, Ian, 1939-"
    And I should see "Rock music--History and criticism."
    And I should see "Rock concert films."
    And I should see "Rock and Roll Hall of Fame and Museum. Annual induction ceremony. 1999."

  Scenario: Facet counts
    Given I am on the home page
    Then I should see "Video 4"
    And I should see "Collection 1"