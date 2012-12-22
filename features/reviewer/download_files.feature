Feature:
  In order to use video
  As a reviewer
  I need to download files

  Scenario: Downloading files (DAM-178)
    Given I am logged in as "reviewer1@example.com"
    And I am on the show document page for rockhall:fixture_pbcore_document3
    Then I should see "Download"