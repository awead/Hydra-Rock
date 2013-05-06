require "spec_helper"

describe Rockhall::Controller::ControllerBehavior do

  class TestClass
    include Rockhall::Controller::ControllerBehavior
  end

  before :each do
    @controller = TestClass.new
  end

  describe "changed_fields" do

    before :each do
      @params = Hash.new
      @params[:id] = "rockhall:fixture_pbcore_document1"
      @params[:document_fields] = Hash.new
    end

    it "should return empty when there aren't any changes" do
      @controller.changed_fields(@params).should be_empty
    end

    it "should return names of changed single-value fields" do
      @params[:document_fields][:title] = "My Title"
      results = @controller.changed_fields(@params)
      results[:title].should == "My Title"
    end

    it "should return the permissions hash" do
      sample_permisisons = {
        "groups"      => {"foo" => "read"},
        "individuals" => {"bar" => "edit"}
      }
      @params[:document_fields][:permissions] = sample_permisisons
      results = @controller.changed_fields(@params)
      results[:permissions].should == sample_permisisons
    end

  end


describe ".format_permissions_hash" do

  it "should reformat the parameters hash so our model can use it" do
    sample_permisisons = {
      "groups" => {
        "foo" => "read",
        "baz" => "discover"
      },
      "users"  => {"bar" => "edit"}
    }
    permissions_hash = @controller.format_permissions_hash(sample_permisisons)
    permissions_hash.should include({:type => "group", :name => "foo", :access => "read"})
    permissions_hash.should include({:type => "user", :name => "bar", :access => "edit"})
  end

end



end