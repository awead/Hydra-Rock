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

You will also need these executeables in your path

* mediainfo
* ffmpegthumbnailer

On Mac, install these both via Homebrew:

    brew install media-info
    brew install ffmpegthumbnailer

Note that ffmpegthumbnailer requires ffmpeg which can take some time.

For other options for Media Info, visit [Media Info's install page](http://mediaarea.net/en/MediaInfo)

### Download

Download Hydra-Rock and run the tests:

    git clone https://github.com/awead/Hydra-Rock
    cd Hydra-Rock
    bundle install
    bundle exec rake

This will download hydra-jetty, run all the necessary configurations, migrations, and run the spec tests.  If all the tests pass
you should be able to run the embedded server and take the application for a spin.

    bundle exec rails server

# Copyright

Copyright (c) 2012 Adam Wead. See LICENSE for details.


