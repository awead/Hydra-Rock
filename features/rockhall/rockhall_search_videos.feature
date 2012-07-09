Feature:
  In order to display video content
  As a public user
  I need to search for videos

  Scenario: search for a video (DAM-83)
    Given I am on the home page
    And I fill in "q" with "rockhall:fixture_pbcore_document1"
    When I press "Search"
    Then I should see "Results"
    And I should see a link to "the show archival video page for rockhall:fixture_pbcore_document1"
    And I should see "Rock and Roll Hall of Fame induction ceremony. Part 1."

  Scenario: search for a video barcode (DAM-83)
    Given I am on the home page
    And I fill in "q" with "39156042551098"
    When I press "Search"
    Then I should see "Results"
    And I should see a link to "the show archival video page for rockhall:fixture_pbcore_document1"
    And I should see "Rock and Roll Hall of Fame induction ceremony. Part 1."

  Scenario: Don't display the results dropdown (DAM-188)
    Given I am on the home page
    Then I should not see "Results"

  Scenario: Searching the abstract field (DAM-151)
    Given I am logged in as "reviewer1@example.com"
    When I fill in "q" with "Old Time Rock"
    And I press "Search"
    Then I should see "Hall of Fame Series. An evening with Little Richard. Pt. 1."

  Scenario: Searching title field (DAM-157)
    Given I am logged in as "reviewer1@example.com"
    And I am on the home page
    When I fill in "q" with "An evening with Little Richard"
    And I press "Search"
    Then I should see "Hall of Fame Series. An evening with Little Richard. Pt. 1."

  Scenario: Searching title field, part 2 (DAM-157)
    Given I am logged in as "reviewer1@example.com"
    And I am on the home page
    When I fill in "q" with "Little Richard"
    And I press "Search"
    Then I should see "Hall of Fame Series. An evening with Little Richard. Pt. 1."