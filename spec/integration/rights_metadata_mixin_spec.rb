require 'spec_helper'

describe Hydra::ModelMixins::RightsMetadata do

  it "should let you set permissions just like other attributes" do
    video = ArchivalVideo.new
    new_attributes = {
      :permissions => [
        {:name=>"group1", :access=>"discover", :type=>'group'},
        {:name=>"group2", :access=>"read", :type=>'group'}
      ],
      :title => "Permissions integration test"
    }
    video.attributes = new_attributes
    video.title.should == "Permissions integration test"
    video.read_groups.should == ["group2"]
    video.discover_groups.should == ["group1"]
  end

end