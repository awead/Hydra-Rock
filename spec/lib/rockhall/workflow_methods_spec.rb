require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require "active_fedora"
require "nokogiri"

describe Rockhall::WorkflowMethods do

  before(:each) do
    class WorkflowTest
      include Rockhall::WorkflowMethods
    end
    @wf = WorkflowTest.new
  end

  describe "new_name" do

    it "should return the new name of an access file" do
      old_name = "111111111_access.mp4"
      pid      = "rrhof:1234"
      new_name = "rrhof_1234_access.mp4"
      test     = @wf.new_name(pid,old_name,{ :type => ["access"] })
      test.should == new_name
    end

    it "should return the name of a type of preservation file" do
      old_name = "111111111_access.mov"
      pid      = "rrhof:1234"
      new_name = "rrhof_1234_preservation_10bit.mov"
      test     = @wf.new_name(pid,old_name,{ :type => ["preservation", "10bit"] })
      test.should == new_name
    end

    it "should return a generic name" do
      old_name = "someBogusThing.pdf"
      pid      = "rrhof:1234"
      new_name = "rrhof_1234.pdf"
      test     = @wf.new_name(pid,old_name)
      test.should == new_name
    end

    it "should rename a folder" do
      old_name = "12345678"
      pid      = "rrhof:1234"
      new_name = "rrhof_1234"
      test     = @wf.new_name(pid,old_name)
      test.should == new_name
    end

  end

  describe "move_content" do

    before(:each) do
      @src = "tmp/src"
      @dst = "tmp/dst"
      FileUtils.touch @src
    end

    after(:each) do
      FileUtils.rm(@src)
      FileUtils.rm(@dst) if File.exists?(@dst)
    end

    it "should move new files to an existing location" do
      @wf.move_content(@src,@dst)
      File.exists?(@dst).should be_true
    end

    it "should not overwrite existing files (default)" do
      FileUtils.touch @dst
      lambda { @wf.move_content(@src,@dst) }.should raise_error(RuntimeError)
    end

    it "should not overwrite existing files with force set to FALSE" do
      pending "Overly pendantic?"
      FileUtils.touch @dst
      lambda { @wf.move_content(@src,@dst,{:force=>FALSE}) }.should raise_error(RuntimeError)
    end

    it "should overwrite existing files using a force option" do
      FileUtils.touch @dst
      lambda { @wf.move_content(@src,@dst,{:force=>TRUE}) }.should_not raise_error(RuntimeError)
    end

  end

  describe "get_file" do

    it "should return a filename if it exists" do
      path = "spec/fixtures/rockhall/sips/39156042439369/data/39156042439369_access.mp4"
      @wf.get_file(path).should == "39156042439369_access.mp4"
    end

    it "should return nil if a file doesn't exist" do
      path = "my/bogus/file.txt"
      @wf.get_file(path).should be_nil
    end

  end

  describe "parsing a date" do

    it "should return a formatted date from a valid string" do
      @wf.parse_date("2011-01-01").should == "2011-01-01"
      @wf.parse_date("10/11/2011").should == "2011-10-11"
    end

    it "should return nil if the string is un-parse-able" do
      @wf.parse_date("foo").should be_nil
      @wf.parse_date("").should be_nil
      @wf.parse_date(nil).should be_nil
    end

  end

  describe "parsing a ratio" do

    it "should return 4:3 when given 4 x 3 or 4 X 3" do
      @wf.parse_ratio("4 X 3").should == "4:3"
      @wf.parse_ratio("4 x 3").should == "4:3"
      @wf.parse_ratio("4x3").should == "4:3"
      @wf.parse_ratio("4X3").should == "4:3"
      @wf.parse_ratio("foo").should be_nil
    end

  end

  describe "parsing a size" do

    it "should return the correct formatted size" do
      @wf.parse_size("123x123").should == "123 x 123"
      @wf.parse_size("123X123").should == "123 x 123"
      @wf.parse_size("123 X 123").should == "123 x 123"
      @wf.parse_size("foo").should be_nil
    end

  end


end
