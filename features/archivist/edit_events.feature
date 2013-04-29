@sample
@javascript
Feature:
  In order to edit items in Hydra
  As an archivist
  I need add and edit fields for events such as place, date and series

  Scenario: Add event series to items
    Given I am logged in as "archivist1@example.com"
    And I am on the subjects workflow page for cucumber:1
    When I follow "open_event_modal"
    And I wait for 2 seconds
    And I fill in "event_value" with "Sample Series"
    And I press "add_event_button"
    And I close the modal window
    And I wait for 2 seconds
    Then the "event_series_0" field should contain "Sample Series"
    When I follow "Remove"
    And I wait for 2 seconds
    Then I should not see "Foo Collection"