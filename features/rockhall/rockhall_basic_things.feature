Feature:
  In order to use Hydra
  As any kind of user
  There need to be some basic features

  Scenario: Clicking on the image logo takes you to the home page
    Given I am on the home page
    When I follow "Test Hydra Head"
    Then I should see "Fedora management application for the digital collections at the Rock and Roll Hall of Fame"