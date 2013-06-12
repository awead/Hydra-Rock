Feature:
  In order to display video content
  As a donor
  I need to view the content of a video

  Scenario: Viewable metadata (DAM-131)
    Given I am logged in as "donor1@example.com"
    And I am on the catalog page for rockhall:fixture_tape2
    Then I should see the main heading "Video: Rock and Roll Hall of Fame induction ceremony. Part 1."
    And I should not see "Edit"
    And I should see the following tabular display:
        | Date            | 1999-03-15      |
        | Barcode         | 39156042551098  |
        | Location        | Rock and Roll Hall of Fame and Museum, 2809 Woodland Ave., Cleveland, OH, 44115 216-515-1956 library@rockhall.org |
        | Physical Format | Betacam         |
        | Standard        | NTSC            | 
        | Media Type      | Moving image    |
        | Generation      | Original        |
        | Language        | eng             |
        | Colors          | Color           |

