Feature:
  In order to integrate with other systems
  As a public user
  I need to export the content of a video in different formats

  @javascript
  Scenario: Export additional formats (DAM-303)
    Given I am on the catalog page for rockhall:fixture_pbcore_document1
    When I follow "Export"
    Then I should see "PBcore"
    And I should see "Solr"
    And I should see "Discovery"

  Scenario: Export pbcore xml
    Given I am on the pbcore xml export page for rockhall:fixture_pbcore_document1

  Scenario: Export solr document
    Given I am on the solr export page for rockhall:fixture_pbcore_document1

  Scenario: Export discovery solr document
    Given I am on the discovery export page for rockhall:fixture_pbcore_document1
