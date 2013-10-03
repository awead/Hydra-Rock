# Hydra-Rock

The Hydra application for the Rock and Roll Hall of Fame

This application isn't publicly available because we run it over our private network to manage our video collection.  
Certain records from our hydra head are available via our [Blacklight catalog](http://catalog.rockhall.com).  To
see an exclusive list of records from our Hydra application, look at 
[this link](http://catalog.rockhall.com/catalog?f%5Bmaterial_facet%5D%5B%5D=Digital) which is a facet query
searching results that originate as videos in our hydra head.

### Features

Our implementation of Hydra focuses on video content, description via PBCore, and large file storage.  We have both
born digital video as well as video that originates in a number of different tape formats.  Every video is stored
on our Tivolli server, using Space Management that migrates data to and from spinning disk to LTO5 tape.

### Fedora Object Model

Hydra allows us to model content using Fedora's 
[digital object model](http://www.fedora-commons.org/download/2.0/userdocs/digitalobjects/objectModel.html).
Our objects, however, do not implement disseminators and simply use datastreams and RDF to relate objects to
one another.

The principle video object is the [ArchivalVideo](archival_video.rb) to which multiple 
[ExternalVideo](external_video.rb) objects are attached.  Archival videos contain metadata, while
the external videos contain additional metadata as well as external datastreams that point to the video files.
Since our video files are very large, files are managed externally via Tivolli and kept outside of Fedora's file management
processes.

External videos may also be non-content bearing, meaning they have no content and only metadata.  An example would be
an external video that represents a tape or other physical object that holds the video data.

### File Storage

Video files are stored on an external system using the [BagIt](https://wiki.ucop.edu/display/Curation/BagIt) structure.

# Installation

To use this software, you will need a full [Hydra stack](https://github.com/projecthydra/hydra-head) and all of its
dependencies.

You will also need MediaInfo available on your machine.  You can install this via Homebrew:

    brew install media-info

For other options, visit [Media Info's install page](http://mediaarea.net/en/MediaInfo)

### Fedora

You will need a copy of Fedora, which is available via the hydra-head gem, but should
be downloaded separately as [hydra-jetty](https://github.com/projecthydra/hydra-jetty).  Once downloaded, you can
start hydra-jetty:

    cd hydra-jetty
    java -XX:+CMSPermGenSweepingEnabled -XX:+CMSClassUnloadingEnabled -XX:PermSize=64M -XX:MaxPermSize=128M -jar start.jar

### Solr

Hydra Jetty includes an instance of solr, however, Hydra-Rock has a different version of solr which can be installed
using our own [solr-jetty](https://github.com/awead/solr-jetty) repository.  Once downloaded, you can start the
solr-jetty instance:

    cd solr-jetty
    java -jar start.jar

Note: hydra-jetty includes solr as well, but runs on port 8983.  Solr Jetty runs on port 8985, so the two can run
concurrently.

### Download

Download Hydra-Rock, run migrations and install the sample fixtures:

    git clone https://github.com/awead/Hydra-Rock
    cd Hydra-Rock
    bundle install
    rake db:migrate
    ./script/test-prep

If you want to run the full set of tests, you can:

    rake spec
    rake cucumber

# Copyright

Copyright (c) 2012 Adam Wead. See LICENSE for details.


