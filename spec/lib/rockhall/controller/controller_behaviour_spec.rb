require File.expand_path(File.dirname(__FILE__) + '../../../../spec_helper')

describe Rockhall::Controller::ControllerBehaviour do

  class TestClass
    include Rockhall::Controller::ControllerBehaviour
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





end