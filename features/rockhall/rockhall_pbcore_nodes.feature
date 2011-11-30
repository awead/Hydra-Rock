Feature:
  In order to catalog video content
  As a library staff user
  I need add and remove different pbcore nodes from documents

  Scenario: Add a new nodes enter information (DAM-131)
    Given I am logged in as "archivist1@example.com"
    And I create a new archival_video
    And I press "Add contributor"
    Then I should see "Contributor"
    And I should not see "Contributor Role:"
    And I should not see "Contributor Ref:"
    And I fill in "asset[descMetadata][contributor_0_name][0]" with "John Doe"
    And I press "Save Document"
    Then I should see "John Doe"
    And I press "Delete John Doe"
    Then I should not see "Contributor"
    And I press "Add publisher"
    Then I should see "Publisher"
    And I should not see "Publisher Role:"
    And I should not see "Publisher Ref:"
    And I fill in "asset[descMetadata][publisher_0_name][0]" with "Jane Doe"
    And I press "Save Document"
    Then I should see "Jane Doe"
    And I press "Delete Jane Doe"
    Then I should not see "Publisher"
    And I press "Add contributor"
    Then I should see "Contributor"
    And I press "Delete #1"
    Then I should not see "Contributor"

  @javascript
  Scenario: Use pull-down menu to update contributor role (DAM-89,90,91)
    Given I am logged in as "archivist1@example.com"
    And I create a new archival_video
    And I press "Add contributor"
    When I select "performer" from "contributor_0_role"
    And I press "Save Document"
    Then I should see "performer"
    And I press "Add publisher"
    When I select "presenter" from "publisher_0_role"
    And I press "Save Document"
    Then I should see "presenter"
    And I follow "Switch to browse view"
    And I should see "performer"
    And I should see "presenter"
