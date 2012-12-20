Feature:
  In order to display video content
  As a public user
  I need to search for videos

  Scenario: search for a video (DAM-83)
    Given I am on the home page
    And I fill in "q" with "rockhall:fixture_pbcore_document1"
    When I press "Search"
    And I should see "Rock and Roll Hall of Fame induction ceremony. Part 1."

  Scenario: search for a video barcode (DAM-83)
    Given I am on the home page
    And I fill in "q" with "39156042551098"
    When I press "Search"
    And I should see "Rock and Roll Hall of Fame induction ceremony. Part 1."
