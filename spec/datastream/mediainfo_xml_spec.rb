require "spec_helper"

describe  MediainfoXml do

  describe "terms from an existing template" do

    before(:all) do
      @doc = MediainfoXml.from_xml(fixture "mediainfo_template.xml")
    end

    it "should find all the terms that need no extra processing" do
      @doc.get_values(:general_count).first.should == "277"
      @doc.get_values(:chroma_subsampling).first.should == "4:2:0"
      @doc.get_values(:color_space).first.should == "YUV"
    end

    it "should return a single number for bit depth" do
      @doc.video_bit_depth.should == "8"
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

    it "should return the file size value" do
      @doc.file_size.last.should == "37.30 MiB"
    end

    it "should return the file format" do
      @doc.mi_file_format.first.should == "MPEG-4"
    end

  end

  describe "calling mediainfo command" do

    it "should raise an error if the file doesn't exist" do
      lambda { MediainfoXml::Document.from_file("foo")}.should raise_error
    end

  end

end