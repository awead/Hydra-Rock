Feature:
  In order to catalog video content
  As an archivist
  I need add and remove different nodes from documents

  @javascript
  Scenario: Add a new nodes enter information (DAM-169)
    Given I am logged in as "archivist1@example.com"
    And I create a new archival video
    And I fill in "archival_video[title]" with "Sample Main Title"
    And I press "Save Changes"
    And I follow "Edit"
    And I follow "Persons"
    And I follow "open_contributor_modal"
    And I wait for 2 seconds
    And I fill in "name" with "John Doe"
    And I select "performer" from "role"
    And I press "add_contributor_button"
    And I close the modal window
    And I wait for 2 seconds
    Then the "contributor_name_0" field should contain "John Doe"
    And the "contributor_role_0" field should contain "performer"
    When I follow "Remove"
    Then I should not see "John Doe"
    And I follow "open_publisher_modal"
    And I wait for 2 seconds
    And I fill in "name" with "Jane Doe"
    And I select "presenter" from "role"
    And I press "add_publisher_button"
    And I close the modal window
    And I wait for 2 seconds    
    Then the "publisher_name_0" field should contain "Jane Doe"
    And the "publisher_role_0" field should contain "presenter"
    When I follow "Remove"
    Then I should not see "Jane Doe"
    And I wait for 2 seconds

  Scenario: Null roles (DAM-169)
    Given I am on the show archival video page for rrhof:331
    Then I should see the field content "blacklight-contributor_name_facet" contain "Mastro, James"
    And I should not see "Mastro, James,"
    And I should not see "Mastro, James ()"