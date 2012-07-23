require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Rockhall::ModelMethods do

  # placeholder for a future tests
  describe "#addl_solr_fields" do

    it "should return a solr doc with additional fields" do
      dv = DigitalVideo.find("rockhall:fixture_pbcore_digital_document1")
      solr_doc = dv.addl_solr_fields
      solr_doc[:access_file_s].should == ["content_001_access.mp4", "content_002_access.mp4", "content_003_access.mp4"]
    end

  end

end
