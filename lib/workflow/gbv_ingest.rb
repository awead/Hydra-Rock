require 'mediainfo'

module Workflow
class GbvIngest

  include Rockhall::WorkflowMethods

  attr_accessor :parent, :sip, :force

  def initialize(sip,opts={})
    raise "Invalid sip" unless sip.valid?
    raise "SIP has no PID.  Did you prepare it?" if sip.pid.nil?
    @sip = sip
    @parent = ArchivalVideo.load_instance(sip.pid)
  end

  # runs the first time to process a new sip that doesn't exist in Fedora
  def process(opts={})
    self.ingest(@sip.base, @sip.access,       "access",       {:format=>"h264"})     unless @parent.videos[:h264]
    self.ingest(@sip.base, @sip.preservation, "preservation", {:format=>"original"}) unless @parent.videos[:original]
  end

  # parent object exists in Fedora and has child objects that need to be reingested
  def reprocess(opts={})
    @parent.remove_file_objects unless @parent.file_objects.empty?
    self.process
  end

  # updates metadata in parent and child objects from metadata in GBV xml
  def update(opts={})
    # Fields in parent
    av = ArchivalVideo.load_instance(sip.pid)
    p_ds = av.datastreams_in_memory["descMetadata"]
    p_ds.update_indexed_attributes( {[:item, :barcode]  => {"0" => @sip.barcode}} )
    p_ds.update_indexed_attributes( {[:full_title]      => {"0" => @sip.title}} )
    p_ds.update_indexed_attributes( {[:coverage, :date] => {"0" => @sip.info(:orig_date)}} ) unless @sip.info(:orig_date).nil?
    p_ds.update_indexed_attributes( {[:item, :standard] => {"0" => @sip.info(:standard)}} ) unless @sip.info(:standard).nil?
    p_ds.update_indexed_attributes( {[:item, :carrier]  => {"0" => @sip.info(:format)}} ) unless @sip.info(:format).nil?
    av.save

    # Fields in preservation video object
    original = ExternalVideo.load_instance(av.videos[:original])
    o_ds = original.datastreams_in_memory["descMetadata"]
    update_preservation_fields(o_ds)
    original.save

    # Fields in access video object
    access = ExternalVideo.load_instance(av.videos[:h264])
    a_ds = original.datastreams_in_memory["descMetadata"]
    update_access_fields(a_ds)
    access.save
  end

  def ingest(base,file,type,opts={})
    # Point to file locations in the BagIt bag
    location  = File.join(RH_CONFIG["host"], base, "data", file)
    directory = File.join(RH_CONFIG["location"], base, "data")

    # Get tech data using MediaInfo
    info      = Mediainfo.new File.join(directory, file)
    ng_info   = Nokogiri::XML::Document.parse(info.raw_response)

    begin
      ev = ExternalVideo.new
      ds = ev.datastreams_in_memory["descMetadata"]
      opts[:format].nil? ? ev.label = "unknown" : ev.label = opts[:format]
      ev.add_named_datastream(type, :label=>file, :dsLocation=>location, :directory=>directory )
      ev.apply_depositor_metadata(RH_CONFIG["depositor"])
      ev.datastreams_in_memory["mediaInfo"].ng_xml = ng_info
      # apply additional tech data from gbv xml
      update_preservation_fields(ds) if type == "preservation"
      update_access_fields(ds) if type == "access"
      ds.update_indexed_attributes( {[:vendor] => {"0" => "George Blood Audio and Video"}} )
      @parent.file_objects_append(ev)
      @parent.save
    rescue Exception=>e
      raise "Failed to add #{type} datastream: #{e}"
    end
  end

  def update_preservation_fields(ds)
    # Instantiation fields
    ds.update_indexed_attributes( {[:date]                                        => {"0" => @sip.info(:p_create_date)}} )     unless @sip.info(:p_create_date).nil?
    ds.update_indexed_attributes( {[:condition]                                   => {"0" => @sip.info(:condition)}} )         unless @sip.info(:condition).nil?
    ds.update_indexed_attributes( {[:cleaning]                                    => {"0" => @sip.info(:cleaning)}} )          unless @sip.info(:cleaning).nil?
    ds.update_indexed_attributes( {[:file_format]                                 => {"0" => @sip.info(:p_file_format)}} )     unless @sip.info(:p_file_format).nil?
    ds.update_indexed_attributes( {[:capture_soft]                                => {"0" => @sip.info(:capture_soft)}} )      unless @sip.info(:capture_soft).nil?
    ds.update_indexed_attributes( {[:operator]                                    => {"0" => @sip.info(:p_operator)}} )        unless @sip.info(:p_operator).nil?
    ds.update_indexed_attributes( {[:trans_note]                                  => {"0" => @sip.info(:p_trans_note)}} )      unless @sip.info(:p_trans_note).nil?
    ds.update_indexed_attributes( {[:device]                                      => {"0" => @sip.info(:device)}} )            unless @sip.info(:device).nil?
    ds.update_indexed_attributes( {[:chroma]                                      => {"0" => @sip.info(:p_chroma)}} )          unless @sip.info(:p_chroma).nil?
    ds.update_indexed_attributes( {[:color_space]                                 => {"0" => @sip.info(:p_color_space)}} )     unless @sip.info(:p_color_space).nil?
    ds.update_indexed_attributes( {[:duration]                                    => {"0" => @sip.info(:p_duration)}} )        unless @sip.info(:p_duration).nil?
    ds.update_indexed_attributes( {[:generation]                                  => {"0" => "Copy: preservation"}} )

    ## Video essence track fields
    ds.update_indexed_attributes( {[{:inst=>0}, {:essence=>0}, :standard]         => {"0" => @sip.info(:standard)}} )               unless @sip.info(:standard).nil?
    ds.update_indexed_attributes( {[{:inst=>0}, {:essence=>0}, :encoding]         => {"0" => @sip.info(:p_video_codec)}} )          unless @sip.info(:p_video_codec).nil?
    ds.update_indexed_attributes( {[{:inst=>0}, {:essence=>0}, :bit_rate]         => {"0" => @sip.info(:p_video_bit_rate)}} )       unless @sip.info(:p_video_bit_rate).nil?
    ds.update_indexed_attributes( {[{:inst=>0}, {:essence=>0}, :bit_rate, :unit]  => {"0" => @sip.info(:p_video_bit_rate_units)}} ) unless @sip.info(:p_video_bit_rate_units).nil?
    ds.update_indexed_attributes( {[{:inst=>0}, {:essence=>0}, :bit_depth]        => {"0" => @sip.info(:p_video_bit_depth)}} )      unless @sip.info(:p_video_bit_depth).nil?
    ds.update_indexed_attributes( {[{:inst=>0}, {:essence=>0}, :frame_rate]       => {"0" => @sip.info(:p_frame_rate)}} )           unless @sip.info(:p_frame_rate).nil?
    ds.update_indexed_attributes( {[{:inst=>0}, {:essence=>0}, :frame_size]       => {"0" => @sip.info(:p_frame_size)}} )           unless @sip.info(:p_frame_size).nil?
    ds.update_indexed_attributes( {[{:inst=>0}, {:essence=>0}, :ratio]            => {"0" => @sip.info(:p_ratio)}} )                unless @sip.info(:p_ratio).nil?


    # Audio essence track fields
    ds.update_indexed_attributes( {[{:inst=>0}, {:essence=>1}, :standard]           => {"0" => @sip.info(:p_audio_standard)}} )               unless @sip.info(:p_audio_standard).nil?
    ds.update_indexed_attributes( {[{:inst=>0}, {:essence=>1}, :encoding]           => {"0" => @sip.info(:p_audio_encoding)}} )               unless @sip.info(:p_audio_encoding).nil?
    ds.update_indexed_attributes( {[{:inst=>0}, {:essence=>1}, :bit_rate]           => {"0" => @sip.info(:p_audio_bit_rate)}} )               unless @sip.info(:p_audio_bit_rate).nil?
    ds.update_indexed_attributes( {[{:inst=>0}, {:essence=>1}, :bit_rate, :unit]    => {"0" => @sip.info(:p_audio_bit_rate_unit)}} )          unless @sip.info(:p_audio_bit_rate_unit).nil?
    ds.update_indexed_attributes( {[{:inst=>0}, {:essence=>1}, :sample_rate]        => {"0" => @sip.info(:p_audio_sample_rate)}} )            unless @sip.info(:p_audio_sample_rate).nil?
    ds.update_indexed_attributes( {[{:inst=>0}, {:essence=>1}, :sample_rate, :unit] => {"0" => @sip.info(:p_audio_sample_rate_unit)}} )       unless @sip.info(:p_audio_sample_rate_unit).nil?
    ds.update_indexed_attributes( {[{:inst=>0}, {:essence=>1}, :bit_depth]          => {"0" => @sip.info(:p_audio_bit_depth)}} )              unless @sip.info(:p_audio_bit_depth).nil?
    ds.update_indexed_attributes( {[{:inst=>0}, {:essence=>1}, :audio_channels]     => {"0" => @sip.info(:p_audio_channels)}} )               unless @sip.info(:p_audio_channels).nil?
  end

  def update_access_fields(ds)
    # Instantiation fields
    ds.update_indexed_attributes( {[:date]                                        => {"0" => @sip.info(:a_create_date)}} )     unless @sip.info(:a_create_date).nil?
    ds.update_indexed_attributes( {[:file_format]                                 => {"0" => @sip.info(:a_file_format)}} )     unless @sip.info(:a_file_format).nil?
    ds.update_indexed_attributes( {[:trans_soft]                                  => {"0" => @sip.info(:trans_soft)}} )        unless @sip.info(:trans_soft).nil?
    ds.update_indexed_attributes( {[:operator]                                    => {"0" => @sip.info(:a_operator)}} )        unless @sip.info(:a_operator).nil?
    ds.update_indexed_attributes( {[:trans_note]                                  => {"0" => @sip.info(:a_trans_note)}} )      unless @sip.info(:a_trans_note).nil?
    ds.update_indexed_attributes( {[:chroma]                                      => {"0" => @sip.info(:a_chroma)}} )          unless @sip.info(:a_chroma).nil?
    ds.update_indexed_attributes( {[:color_space]                                 => {"0" => @sip.info(:a_color_space)}} )     unless @sip.info(:a_color_space).nil?
    ds.update_indexed_attributes( {[:duration]                                    => {"0" => @sip.info(:a_duration)}} )        unless @sip.info(:a_duration).nil?
    ds.update_indexed_attributes( {[:generation]                                  => {"0" => "Copy: access"}} )

    # Video essence track fields
    ds.update_indexed_attributes( {[{:inst=>0}, {:essence=>0}, :standard]         => {"0" => @sip.info(:standard)}} )               unless @sip.info(:standard).nil?
    ds.update_indexed_attributes( {[{:inst=>0}, {:essence=>0}, :encoding]         => {"0" => @sip.info(:a_video_codec)}} )          unless @sip.info(:a_video_codec).nil?
    ds.update_indexed_attributes( {[{:inst=>0}, {:essence=>0}, :bit_rate]         => {"0" => @sip.info(:a_video_bit_rate)}} )       unless @sip.info(:a_video_bit_rate).nil?
    ds.update_indexed_attributes( {[{:inst=>0}, {:essence=>0}, :bit_rate, :unit]  => {"0" => @sip.info(:a_video_bit_rate_units)}} ) unless @sip.info(:a_video_bit_rate_units).nil?
    ds.update_indexed_attributes( {[{:inst=>0}, {:essence=>0}, :bit_depth]        => {"0" => @sip.info(:a_video_bit_depth)}} )      unless @sip.info(:a_video_bit_depth).nil?
    ds.update_indexed_attributes( {[{:inst=>0}, {:essence=>0}, :frame_rate]       => {"0" => @sip.info(:a_frame_rate)}} )           unless @sip.info(:a_frame_rate).nil?
    ds.update_indexed_attributes( {[{:inst=>0}, {:essence=>0}, :frame_size]       => {"0" => @sip.info(:a_frame_size)}} )           unless @sip.info(:a_frame_size).nil?
    ds.update_indexed_attributes( {[{:inst=>0}, {:essence=>0}, :ratio]            => {"0" => @sip.info(:a_ratio)}} )                unless @sip.info(:a_ratio).nil?
    #ds.update_indexed_attributes( {[{:inst=>0}, {:essence=>0}, :chroma]           => {"0" => @sip.info(:a_chroma)}} )               unless @sip.info(:a_chroma).nil?
    #ds.update_indexed_attributes( {[{:inst=>0}, {:essence=>0}, :color_space]      => {"0" => @sip.info(:a_colors)}} )               unless @sip.info(:a_colors).nil?

    # Audio essence track fields
    ds.update_indexed_attributes( {[{:inst=>0}, {:essence=>1}, :standard]           => {"0" => @sip.info(:a_audio_standard)}} )               unless @sip.info(:a_audio_standard).nil?
    ds.update_indexed_attributes( {[{:inst=>0}, {:essence=>1}, :encoding]           => {"0" => @sip.info(:a_audio_encoding)}} )               unless @sip.info(:a_audio_encoding).nil?
    ds.update_indexed_attributes( {[{:inst=>0}, {:essence=>1}, :bit_rate]           => {"0" => @sip.info(:a_audio_bit_rate)}} )               unless @sip.info(:a_audio_bit_rate).nil?
    ds.update_indexed_attributes( {[{:inst=>0}, {:essence=>1}, :bit_rate, :unit]    => {"0" => @sip.info(:a_audio_bit_rate_unit)}} )          unless @sip.info(:a_audio_bit_rate_unit).nil?
    ds.update_indexed_attributes( {[{:inst=>0}, {:essence=>1}, :sample_rate]        => {"0" => @sip.info(:a_audio_sample_rate)}} )            unless @sip.info(:a_audio_sample_rate).nil?
    ds.update_indexed_attributes( {[{:inst=>0}, {:essence=>1}, :sample_rate, :unit] => {"0" => @sip.info(:a_audio_sample_rate_unit)}} )       unless @sip.info(:a_audio_sample_rate_unit).nil?
    ds.update_indexed_attributes( {[{:inst=>0}, {:essence=>1}, :bit_depth]          => {"0" => @sip.info(:a_audio_bit_depth)}} )              unless @sip.info(:a_audio_bit_depth).nil?
    ds.update_indexed_attributes( {[{:inst=>0}, {:essence=>1}, :audio_channels]     => {"0" => @sip.info(:a_audio_channels)}} )               unless @sip.info(:a_audio_channels).nil?
  end


end
end
