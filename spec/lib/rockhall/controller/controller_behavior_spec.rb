require "spec_helper"

describe Rockhall::Controller::ControllerBehavior do

  class TestClass
    include Rockhall::Controller::ControllerBehavior
  end

  before :each do
    @controller = TestClass.new

  end

  describe "get_model_from_pid" do

    it "should return the name of model" do
      av = ArchivalVideo.find("rockhall:fixture_pbcore_document1")
      @controller.get_model_from_pid(av.pid).should == av
      dv = DigitalVideo.find("rockhall:fixture_pbcore_digital_document1")
      @controller.get_model_from_pid(dv.pid).should == dv
      ev = ExternalVideo.find("rockhall:fixture_pbcore_document3_original")
      @controller.get_model_from_pid(ev.pid).should == ev
    end

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

  end




end