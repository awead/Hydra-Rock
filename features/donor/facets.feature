Feature:
  In order to find content in Hydra
  As a donor
  I need to browse different facets

  Scenario: Available facets
    Given I am logged in as "donor1@example.com"
    And I am on the home page
    Then I should see facets for:
      | Media Type |
      | Physical Format |
      | Name |
      | Subject |
      | Genre |
      | Event/Series |
      | Reviewed |
      | Creation Date |
      | Language |
      | Priority |
      | Depositor |
      | Reviewer |