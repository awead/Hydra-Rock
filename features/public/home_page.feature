Feature:
  Checking the Hydra home page
  As any kind of user
  There is some required content

  Scenario: Clicking on the image logo takes you to the home page
    Given I am on the home page
    When I follow "Hydra"
    Then I should see "Hydra is an open-source digital asset management system"
