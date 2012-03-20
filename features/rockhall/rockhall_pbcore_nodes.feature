Feature:
  In order to catalog video content
  As a library staff user
  I need add and remove different pbcore nodes from documents

  Scenario: Add a new nodes enter information (DAM-169)
    Given I am logged in as "archivist1@example.com"
    And I create a new archival_video
    And I fill in "asset[descMetadata][main_title][0]" with "Sample Main Title"
    And I press "Submit"
    And I choose "wf_step_persons"
    And I press "Go to"
    Then I should see "Contributors"
    And I press "Add contributor"
    And I fill in "asset[descMetadata][contributor_0_name][0]" with "John Doe"
    And I press "Submit"
    Then the "contributor_0_name" field within "#contributor" should contain "John Doe"
    And I press "Delete John Doe"
    Then I should not see "John Doe"
    And I press "Add publisher"
    Then I should see "Publisher"
    And I fill in "asset[descMetadata][publisher_0_name][0]" with "Jane Doe"
    And I press "Submit"
    Then the "publisher_0_name" field within "#publisher" should contain "Jane Doe"
    And I press "Delete Jane Doe"
    Then I should not see "Jane Doe"
    And I press "Add contributor"
    Then I should see "Contributor"
    And I press "Delete #1"
    Then I should see "Contributors"

  @javascript
  Scenario: Use pull-down menu to update contributor role (DAM-169)
    Given I am logged in as "archivist1@example.com"
    And I create a new archival_video
    And I fill in "asset[descMetadata][main_title][0]" with "Sample Main Title"
    And I press "Submit"
    And I choose "wf_step_persons"
    And I press "Go to"
    Then I should see "Contributors"
    And I press "Add contributor"
    When I select "performer" from "contributor_0_role"
    And I press "Submit"
    Then I should see "performer"
    And I press "Add publisher"
    When I select "presenter" from "publisher_0_role"
    And I press "Submit"
    Then I should see "presenter"
    And I follow "Switch to browse view"
    And I should see "performer"
    And I should see "presenter"

  Scenario: Null roles (DAM-169)
    Given I am logged in as "archivist1@example.com"
    And I create a new archival_video
    And I fill in "asset[descMetadata][main_title][0]" with "Sample Main Title for null roles"
    And I press "Submit"
    And I choose "wf_step_persons"
    And I press "Go to"
    Then I should see "Contributors"
    And I press "Add contributor"
    And I press "Add publisher"
    And I fill in "asset[descMetadata][contributor_0_name][0]" with "John Doe"
    And I fill in "asset[descMetadata][publisher_0_name][0]" with "No One"
    And I press "Submit"
    When I follow "Switch to browse view"
    Then I should see "John Doe"
    And I should see "No One"
    And I should not see "John Doe,"
    And I should not see "No One,"