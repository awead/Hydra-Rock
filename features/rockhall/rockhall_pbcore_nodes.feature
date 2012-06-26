Feature:
  In order to catalog video content
  As a library staff user
  I need add and remove different pbcore nodes from documents

  @javascript
  Scenario: Add a new nodes enter information (DAM-169)
    Given I am logged in as "archivist1@example.com"
    And I create a new archival video
    And I fill in "archival_video[main_title]" with "Sample Main Title"
    And I press "Save Changes"
    And I follow "Persons"
    And I follow "Contributor"
    And I fill in "document_fields[contributor_name][0]" with "John Doe"
    And I press "Save Changes"
    Then the "contributor_name_0" field should contain "John Doe"
    When I follow "Delete"
    Then I should not see "John Doe"
    And I follow "Publisher"
    And I fill in "document_fields[publisher_name][0]" with "Jane Doe"
    And I press "Save Changes"
    Then the "publisher_name_0" field should contain "Jane Doe"
    When I follow "Delete"
    Then I should not see "Jane Doe"

  Scenario: Use pull-down menu to update contributor role (DAM-169)
    Given I am logged in as "archivist1@example.com"
    And I create a new archival video
    And I fill in "archival_video[main_title]" with "Sample Main Title"
    And I press "Save Changes"
    And I follow "Persons"
    And I follow "Contributor"
    When I select "performer" from "contributor_role_0"
    And I press "Save Changes"
    Then I should see "performer"
    And I follow "Publisher"
    When I select "presenter" from "publisher_role_0"
    And I press "Save Changes"
    Then I should see "presenter"

  Scenario: Null roles (DAM-169)
    Given I am logged in as "archivist1@example.com"
    And I create a new archival video
    And I fill in "archival_video[main_title]" with "Sample Main Title"
    And I press "Save Changes"
    And I follow "Persons"
    And I follow "Contributor"
    And I follow "Publisher"
    And I fill in "document_fields[contributor_name][0]" with "John Doe"
    And I fill in "document_fields[publisher_name][0]" with "No One"
    And I press "Save Changes"
    When I follow "View"
    Then I should see "John Doe"
    And I should see "No One"
    And I should not see "John Doe,"
    And I should not see "No One,"