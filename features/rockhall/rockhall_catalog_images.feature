Feature: Catalog images
  In order to describe digital images
  As a librarian
  I will need to enter all the necessary metadata
  
  Scenario: search images
    Given I am on the home page
    And I fill in "q" with "Darren Grealish"
    When I press "search"
    Then I should see a link to "the show document page for rockhall:fixture_mods_image1"
    And I should see "Electric Prunes with the Strawberry Alarm Clock December 28"

	Scenario: public image
    Given I am on the show document page for rockhall:fixture_mods_image1
    Then I should see "Electric Prunes with the Strawberry Alarm Clock December 28"
    And I should see "Grealish"
    And I should see "Darren"
    And I should see "Still image."
    And I should see "English."
    And I should see "1 sheet : col. ; 14 x 16 in."
    And I should see "852 KB"
    And I should not see "852 KB1 sheet : col. ; 14 x 16 in."
    And I should see "Corporate Subject"
    And I should see "Topic Subject"
    And I should see "Electric Prunes (Musical group)"
    And I should see "Strawberry Alarm Clock (Musical group)"
    And I should see "Rock music"
    And I should see "Posters"
    And I should see "Los Angeles, Calif."
    And I should see "Biff! Bang! Pow! Studio,"
    And I should see "2007"
    And I should see "Rock posters"
    And I should see "John Doe Test Collection (Rock and Roll Hall of Fame and Museum. Library and Archives.)"
    And I should see "ARC.TEST"
    And I should see "Rock and Roll Hall of Fame and Museum, Library and Archives, 2809 Woodland Ave., Cleveland, Ohio 44115"
    And I should see the image "rockhall:fixture_mods_image1/screen"
    And I should not see a link to "the edit document page for hydrangea:fixture_mods_article1"

  Scenario: edit page
    Given I am logged in as "archivist1" 
    And I am on the edit document page for rockhall:fixture_mods_image1
    Then I should see "Electric Prunes with the Strawberry Alarm Clock December 28" within "h1.document_heading"
    And I should see an inline edit containing "Electric Prunes with the Strawberry Alarm Clock December 28"

  Scenario: browse/edit buttons
    Given I am logged in as "archivist1" 
    And I am on the edit document page for rockhall:fixture_mods_image1
    Then I should see a "span" tag with a "class" attribute of "edit-browse"
  
  Scenario: upload image
  
  Scenario: create derrivatives (optional)
  
  Scenario: enter metadata
  
  Scenario: verify presence of image and metadata
