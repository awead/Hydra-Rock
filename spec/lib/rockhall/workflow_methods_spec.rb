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
      path = "spec/fixtures/rockhall/sips/11111111/11111111_access.mp4"
      @wf.get_file(path).should == "11111111_access.mp4"
    end

    it "should return nil if a file doesn't exist" do
      path = "my/bogus/file.txt"
      @wf.get_file(path).should be_nil
    end

  end

  describe "get_checksum" do

    it "should return the checksum string from a given file" do
      path = "spec/fixtures/rockhall/sips/11111111/11111111_access.mp4.md5"
      @wf.get_checksum(path).should == "1951cfc1a30b453a6e45036e60df4382"
    end

    it "should return nil if the file doesn't exist" do
      path = "my/bogus/checksum.sha"
      @wf.get_checksum(path).should be_nil
    end

  end

end
