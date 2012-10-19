require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Rockhall::Discovery do


  describe "#get_objects" do

    before(:all) do
      Rockhall::JettyCleaner.clean(RH_CONFIG["pid_space"])
      solrizer = Solrizer::Fedora::Solrizer.new
      solrizer.solrize_objects
    end

    after(:all) do
      Rockhall::JettyCleaner.clean(RH_CONFIG["pid_space"])
      solrizer = Solrizer::Fedora::Solrizer.new
      solrizer.solrize_objects
      Rockhall::Discovery.delete_objects
      Rockhall::Discovery.update
    end

    it "should delete all ArchivalVideos from the remote Blacklight index" do
      Rockhall::Discovery.delete_objects
      docs = Rockhall::Discovery.get_objects({:remote=>TRUE})
      docs.should be_empty
    end

    it "should return a list of current documents" do
      docs = Rockhall::Discovery.get_objects
      docs.count.should == 2
    end

    it "should return an updated list of new videos" do
      av = ArchivalVideo.new
      av.main_title = "Sample title"
      av.datastreams["rightsMetadata"].update_permissions( "group"=>{"public"=>"read"} )
      av.save
      docs = Rockhall::Discovery.get_objects
      docs.count.should == 3
    end

    it "should update the Blacklight index with new videos" do
      pending "Forcoming blacklight solr update"
      Rockhall::Discovery.update
      docs = Rockhall::Discovery.get_objects({:remote=>TRUE})
      docs.count.should == 2
    end

  end


end