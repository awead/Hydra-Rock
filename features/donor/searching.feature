Feature:
  In order to display video content
  As a donor
  I need to search for videos

  Scenario: search for a video barcode (DAM-83)
    Given I am logged in as "donor1@example.com"
    And I am on the home page
    And I fill in "q" with "39156042551098"
    When I press "Search"
    And I should see "Rock and Roll Hall of Fame induction ceremony. Part 1."