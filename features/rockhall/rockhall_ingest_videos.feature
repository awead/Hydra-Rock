Feature: Ingest videos
  In order to ingest digital videos into Hydra
  As as archivist
  Submit bags of video

Narrative:
  We'll receive video from either vendors or internall that has been organized into a BagIt
  structure.  These packages (SIPs) will be verified, prepared and ingested using methods
  executed from a command line and rake environment.  Once the video is successfully ingested
  there will be objects that exist in Hydra ready for viewing and editing.

  Scenario: Video is not publically available immediately following ingest
    Given I am on the show document page for rockhall:fixture_pbcore_document3
    Then I should see "You do not have sufficient access privileges to read this document, which has been marked private."

  Scenario: Members of the archivist group have edit rights (DAM-131)
    Given I am logged in as "archivist1@example.com"
    And I am on the view archival_video page for rockhall:fixture_pbcore_document3
    Then I should see "Rock-n-Roll Hall of Fame. The craft. Jim James. @ the Belly Up, San Diego. Main mix, stereo. Part 2 of 2."
    And I should see "2007-07-09"
    And I should see "Betacam"
    And I should see "NTSC"
    And I should see "Rock and Roll Hall of Fame and Museum, 2809 Woodland Ave., Cleveland, OH, 44115 216-515-1956 library@rockhall.org"

  Scenario: View all the fields of the original preservation video file
    Given I am logged in as "archivist1@example.com"
    And I am on the view external_video page for rockhall:fixture_pbcore_document3_original
    Then I should see "39156042439369_preservation.mov"
    And I should see "0"
    And I should see "2011-10-12"
    And I should see "George Blood Audio and Video"
    And I should see "Copy: preservation"
    And I should see "Moving image"
    And I should see "Color"
    And I should see "Bars and tone at end of program"
    And I should see "mov"
    And I should see "Apple FCP 7 (ver 7.0.3)"
    And I should see "TMu"
    And I should see "Sony PVW-2800; 20040"
    And I should see "4:2:2"
    And I should see "YUV"
    And I should see "NTSC"
    And I should see "AJA v210"
    And I should see "224 (Mbps)"
    And I should see "10"
    And I should see "720x486"
    And I should see "29.97 (fps)"
    And I should see "4:3"
    And I should see "Linear PCM Audio"
    And I should see "in24"
    And I should see "1152 (Kbps)"
    And I should see "48 (kHz)"
    And I should see "24"
    And I should see "2"

  Scenario: View all the fields of the access h264 video file
    Given I am logged in as "archivist1@example.com"
    And I am on the view external_video page for rockhall:fixture_pbcore_document3_h264
    Then I should see "39156042439369_access.mp4"
    And I should see "0"
    And I should see "2011-10-12"
    And I should see "George Blood Audio and Video"
    And I should see "Copy: access"
    And I should see "Moving image"
    And I should see "Color"
    And I should see "mp4"
    And I should see "MPEG Streamclip 1.92"
    And I should see "TMu"
    And I should see "4:2:0"
    And I should see "YUV"
    And I should see "NTSC"
    And I should see "H.264/MPEG-4 AVC"
    And I should see "2507 (Kbps)"
    And I should see "8"
    And I should see "640x480"
    And I should see "29.97 (fps)"
    And I should see "4:3"
    And I should see "AAC"
    And I should see "MPEG-4: AAC"
    And I should see "256 (Kbps)"
    And I should see "48.0 (kHz)"
    And I should see "16"
    And I should see "2"


