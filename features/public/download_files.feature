Feature:
  When using Hydra
  As a public person
  I should not be able to download files

  Scenario: Downloading files (DAM-178)
    Given I am on the show document page for rockhall:fixture_pbcore_document3
    Then I should not see "Download"
    And I should not see "Video Files"