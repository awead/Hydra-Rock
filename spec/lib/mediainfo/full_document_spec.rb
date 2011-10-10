require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require "active_fedora"
require "nokogiri"
require "equivalent-xml"

describe Mediainfo::FullDocument do

  describe "terms from an existing template" do

    before(:all) do
      file = File.new("spec/fixtures/mediainfo/mediainfo_template.xml")
      @doc = Mediainfo::FullDocument.from_xml(file)
    end

    it "should find all the terms that need no extra processing" do
      @doc.get_values(:general_count).first.should == "277"
      @doc.get_values(:chroma_subsampling).first.should == "4:2:0"
      @doc.get_values(:color_space).first.should == "YUV"
    end

    it "should return a single number for bit depth" do
      @doc.bit_depth.should == "8"
    end

    it "should return a colon ratio string for aspect ratio" do
      @doc.aspect_ratio.should == "16:9"
    end

    it "should return the formatted values of width and height" do
      @doc.frame_size.should == "424x240"
    end

    it "should return the correct formatted string for duration" do
      @doc.duration.should == "00:09:56.458"
    end

  end

  describe "calling mediainfo command" do

    it "should raise an error if the file doesn't exist" do
      lambda { Mediainfo::FullDocument.from_file("foo")}.should raise_error
    end

  end

end