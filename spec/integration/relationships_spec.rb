require "spec_helper"

# Tests the relationships between collections, components and content models such as ArchivalVideo.
# Uses the following dummy structure:
#
#            ArchivalCollection
#                    |
#          -----------------------
#         |                       |
# ArchivalComponent-1      ArchivalComponent-2
#         |                       |
# ArchivalComponent-3        ArchivalVideo-1
#         |
#   ArchivalVideo-2
#
# * isMemeberofCollection: All ArchivalComponent and ArchivalVideo objects are memebers of the collection ArchivalCollection
# * isSubSetof: ArchivalComponet-3 is a subset of ArchivalComponet-1
#

describe "Archival relationships" do

  after :all do
    Rockhall::JettyCleaner.clean(RH_CONFIG["pid_space"])
  end
    
  it "should relate components to collections, and videos to both components and collections" do
    coll = ArchivalCollection.new
    c1   = ArchivalComponent.new
    c2   = ArchivalComponent.new
    c3   = ArchivalComponent.new
    v1   = ArchivalVideo.new
    v1.title = "Video 1"
    v2   = ArchivalVideo.new
    v2.title = "Video 2"
    coll.save
    c1.save
    c2.save
    c3.save
    v1.save
    v2.save
    coll.series = [c1, c2, c3]
    coll.videos = [v1, v2]
    c1.sub_series << c3
    c2.videos << v1
    c3.videos << v2
    coll.save
    c1.save
    c2.save
    c3.save
    v1.save
    v2.save
        
    c1.collection.pid.should       == coll.pid
    c2.collection.pid.should       == coll.pid
    c3.collection.pid.should       == coll.pid
    c1.sub_series.first.pid.should == c3.pid
    c3.series.pid.should           == c1.pid
    c2.videos.first.pid.should     == v1.pid
    c3.videos.first.pid.should     == v2.pid
    v1.collection.pid.should       == coll.pid
    v2.collection.pid.should       == coll.pid
    v1.series.pid.should           == c2.pid
    v2.series.pid.should           == c3.pid
    coll.series.length.should      == 3
    coll.videos.length.should      == 2
    coll.series.collect { |c| c.should be_kind_of(ArchivalComponent) }
    coll.videos.collect { |c| c.should be_kind_of(ArchivalVideo) }

  end
end