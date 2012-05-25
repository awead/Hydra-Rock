require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ArchivalVideosController do

  describe "create" do
    it "should create a new archival video" do
      get :new
    end
  end

  describe "changed_fields" do
    it "should return an array of only the fields that have changed"
      pending
    end
  end


end
