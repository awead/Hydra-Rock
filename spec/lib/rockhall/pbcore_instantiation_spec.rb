require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require "active_fedora"
require "nokogiri"
require "equivalent-xml"

describe Rockhall::PbcoreInstantiation do

  before(:each) do
    Fedora::Repository.stubs(:instance).returns(stub_everything())
    @object_ds = Rockhall::PbcoreInstantiation.new
  end

  describe ".new" do
    it "should initialize a new PBCore instantiation template if no xml is provided" do
      article_ds = Rockhall::PbcoreInstantiation.new
      article_ds.ng_xml.to_xml.should == Rockhall::PbcoreInstantiation.xml_template.to_xml
    end
  end

  describe ".update_indexed_attributes" do
    it "should update all of the fields in #xml_template and fields not requiring additional inserted nodes" do
      [
        [:name],
        [:date],
        [:generation],
        [:generation, :ref],
        [:file_format],
        [:size],
        [:size, :units],
        [:colors],
        [:colors, :ref],
        [:duration],
        [:link],
        [:rights_summary],
        [:rights_link],
        [:chksum_type],
        [:chksum_value],
        [:device],
        [:capture_soft],
        [:trans_soft],
        [:operator],
        [:trans_note],
        [:vendor],
        [:condition],
        [:cleaning],
        [:note],
        [:chroma],
        [:color_space]
      ].each do |pointer|
        test_val = "#{pointer.last.to_s} value"
        @object_ds.update_indexed_attributes( {pointer=>{"0"=>test_val}} )
        @object_ds.get_values(pointer).first.should == test_val
        @object_ds.get_values(pointer).length.should == 1
      end
    end
  end

  describe "#xml_template" do
    it "should return an empty xml document matching an exmplar" do
      f = File.open("#{Rails.root.to_s}/spec/fixtures/rockhall/pbcore_instantiation_template.xml")
      ref_node = Nokogiri::XML(f)
      f.close
      sample_node = Nokogiri::XML(@object_ds.to_xml)
      EquivalentXml.equivalent?(ref_node, sample_node, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
    end
  end

  describe "essence fields" do

    it "should be different for audio and video tracks" do

      # Type
      @object_ds.get_values([{:inst=>0}, {:essence=>0}, :type]).first.should == "Video"
      @object_ds.get_values([{:inst=>0}, {:essence=>1}, :type]).first.should == "Audio"

      # Standard
      @object_ds.update_indexed_attributes({ [{:inst=>0}, {:essence=>0}, :standard] => {"0" => "video standard"}} )
      @object_ds.update_indexed_attributes({ [{:inst=>0}, {:essence=>1}, :standard] => {"0" => "audio standard"}} )
      @object_ds.get_values([{:inst=>0}, {:essence=>0}, :standard]).first.should == "video standard"
      @object_ds.get_values([{:inst=>0}, {:essence=>1}, :standard]).first.should == "audio standard"

      # Encoding
      @object_ds.update_indexed_attributes({ [{:inst=>0}, {:essence=>0}, :encoding] => {"0" => "video encoding"}} )
      @object_ds.update_indexed_attributes({ [{:inst=>0}, {:essence=>1}, :encoding] => {"0" => "audio encoding"}} )
      @object_ds.get_values([{:inst=>0}, {:essence=>0}, :encoding]).first.should == "video encoding"
      @object_ds.get_values([{:inst=>0}, {:essence=>1}, :encoding]).first.should == "audio encoding"

      # Bit rate
      @object_ds.update_indexed_attributes({ [{:inst=>0}, {:essence=>0}, :bit_rate] => {"0" => "video bit rate"}} )
      @object_ds.update_indexed_attributes({ [{:inst=>0}, {:essence=>1}, :bit_rate] => {"0" => "audio bit rate"}} )
      @object_ds.get_values([{:inst=>0}, {:essence=>0}, :bit_rate]).first.should == "video bit rate"
      @object_ds.get_values([{:inst=>0}, {:essence=>1}, :bit_rate]).first.should == "audio bit rate"

      # Bit rate units
      @object_ds.update_indexed_attributes({ [{:inst=>0}, {:essence=>0}, :bit_rate, :unit] => {"0" => "video bit rate unit"}} )
      @object_ds.update_indexed_attributes({ [{:inst=>0}, {:essence=>1}, :bit_rate, :unit] => {"0" => "audio bit rate unit"}} )
      @object_ds.get_values([{:inst=>0}, {:essence=>0}, :bit_rate, :unit]).first.should == "video bit rate unit"
      @object_ds.get_values([{:inst=>0}, {:essence=>1}, :bit_rate, :unit]).first.should == "audio bit rate unit"

      # Bit depth
      @object_ds.update_indexed_attributes({ [{:inst=>0}, {:essence=>0}, :bit_depth] => {"0" => "10"}} )
      @object_ds.update_indexed_attributes({ [{:inst=>0}, {:essence=>1}, :bit_depth] => {"0" => "24"}} )
      @object_ds.get_values([{:inst=>0}, {:essence=>0}, :bit_depth]).first.should       == "10"
      @object_ds.get_values([{:inst=>0}, {:essence=>1}, :bit_depth]).first.should       == "24"

      # Video only
      @object_ds.update_indexed_attributes({ [{:inst=>0}, {:essence=>0}, :frame_rate] => {"0" => "frame rate"}} )
      @object_ds.update_indexed_attributes({ [{:inst=>0}, {:essence=>0}, :frame_size] => {"0" => "frame size"}} )
      @object_ds.update_indexed_attributes({ [{:inst=>0}, {:essence=>0}, :ratio] => {"0" => "ratio"}} )
      @object_ds.get_values([{:inst=>0}, {:essence=>0}, :frame_rate]).first.should == "frame rate"
      @object_ds.get_values([{:inst=>0}, {:essence=>0}, :frame_size]).first.should == "frame size"
      @object_ds.get_values([{:inst=>0}, {:essence=>0}, :ratio]).first.should == "ratio"

      # Audio only
      @object_ds.update_indexed_attributes({ [{:inst=>0}, {:essence=>1}, :sample_rate] => {"0" => "sample rate"}} )
      @object_ds.update_indexed_attributes({ [{:inst=>0}, {:essence=>1}, :sample_rate, :unit] => {"0" => "sample rate units"}} )
      @object_ds.update_indexed_attributes({ [{:inst=>0}, {:essence=>1}, :audio_channels] => {"0" => "2"}} )
      @object_ds.get_values([{:inst=>0}, {:essence=>1}, :sample_rate]).first.should == "sample rate"
      @object_ds.get_values([{:inst=>0}, {:essence=>1}, :sample_rate, :unit]).first.should == "sample rate units"
      @object_ds.get_values([{:inst=>0}, {:essence=>1}, :audio_channels]).first.should == "2"

    end

  end

end
