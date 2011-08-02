require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Rockhall::ModelMethods do
  
  describe "insert subject" do
    it "should instert subject node for given parameter" do
      pending "Need to write this one"
      #prop_ds = mock("properties ds")
      #rights_ds = mock("rights ds")
      #prop_ds.expects(:respond_to?).with(:depositor_values).returns(true)
      #prop_ds.expects(:depositor_values=).with("foouser")
      #rights_ds.expects(:update_indexed_attributes).with([:edit_access, :person]=>"foouser")

      #helper.stubs(:datastreams_in_memory).returns({"rightsMetadata"=>rights_ds,"properties"=>prop_ds})
      #helper.apply_depositor_metadata("foouser")
    end
  end

  describe "remove subject" do
    it "should remove xml node for given subject parameter" do
      pending "Need to write this one"
      #prop_ds = mock("properties ds")
      #prop_ds.expects(:respond_to?).with(:collection_values).returns(true)
      #prop_ds.expects(:collection_values=).with("hydrangea_article")

      #helper.stubs(:datastreams_in_memory).returns({"properties"=>prop_ds})
      #helper.set_collection_type("hydrangea_article")
    end
  end
  
end
