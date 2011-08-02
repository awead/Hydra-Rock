Feature: Ingest videos
  In order to ingest digital videos into Hydrangea
  As the AV archivist
  I need to upload folders of videos.
  
Narrative:
  Prior to ingest, a catalog record of the video will be created in Hydrangea
  with applicable metadata, and a specification of the files that will be
  ingested such as one or more preservation formats and one or more access
  formats. The user then creates a folder with these files in them and copies
  them to network location. The application then checks the contents of the
  folder for accuracy and load them into Fedora.

  Scenario: Files slated for ingest - user enters file names
  
  Scenario: Successful ingest - all files are correctly loaded into Fedora
  
  Scenario: Incomplete ingest - not all the files get loaded into Fedora
  
  Scenario: Missing files - one or more files are missing from the folder
  
  Scenario: Incorrect files - one of more of the files are of the wrong type
