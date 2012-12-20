Feature:
  Checking the Hydra home page
  As any kind of user
  There is some required content

  Scenario: Clicking on the image logo takes you to the home page
    Given I am on the home page
    When I follow "Hydra"
    Then I should see "Hydra is an open-source digital asset management system"

  Scenario: Don't display the results dropdown until I have searches (DAM-188)
    Given I am on the home page
    Then I should not see "Results"
