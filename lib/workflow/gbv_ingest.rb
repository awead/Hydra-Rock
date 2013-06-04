require 'mediainfo'

module Workflow
class GbvIngest

  include Rockhall::WorkflowMethods

  attr_accessor :parent, :sip, :force

  def initialize(sip,opts={})
    raise "Invalid sip" unless sip.valid?
    raise "SIP has no PID.  Did you prepare it?" if sip.pid.nil?
    @sip = sip
    @parent = ArchivalVideo.find(sip.pid)
  end

  # runs the first time to process a new sip that doesn't exist in Fedora
  def process(opts={})
    self.ingest(@sip.base, @sip.access,       "access",       {:format=>"h264"})     unless @parent.videos[:access].first
    self.ingest(@sip.base, @sip.preservation, "preservation", {:format=>"original"}) unless @parent.videos[:preservation].first
    
    # add thumbnail
    if generate_video_thumbnail(File.join(RH_CONFIG["location"], @sip.base, "data", @sip.access))
      @parent.add_thumbnail File.new("tmp/thumb.jpg")
    end
  end

  # parent object exists in Fedora and has child objects that need to be reingested
  def reprocess(opts={})
    @parent.remove_external_videos unless @parent.external_videos.empty?
    puts self.sip.pid
    av = ArchivalVideo.find(self.sip.pid)
    @parent = av
    self.process
  end

  # updates metadata in parent and child objects from metadata in GBV xml
  def update(opts={})
    # Fields in parent
    av = ArchivalVideo.find(sip.pid)
    av.title         = @sip.title

    # Update the fields in the external video representing the tape
    av.videos[:original].first.barcode  = @sip.barcode
    av.videos[:original].first.date     = @sip.info(:orig_date) unless @sip.info(:orig_date).nil?
    av.videos[:original].first.standard = @sip.info(:standard)  unless @sip.info(:standard).nil?
    av.videos[:original].first.format   = @sip.info(:format)    unless @sip.info(:format).nil?
    av.videos[:original].first.save

    # Fields in preservation video object
    original = ExternalVideo.find(av.videos[:preservation].first.pid)
    update_preservation_fields(original)
    original.save

    # Fields in access video object
    access = ExternalVideo.find(av.videos[:access].first.pid)
    update_access_fields(access)
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
      ev.define_digital_instantiation
      ev.save
      opts[:format].nil? ? ev.label = "unknown" : ev.label = opts[:format]
      ev.add_named_datastream(type, :label=>file, :dsLocation=>location, :directory=>directory )
      ev.apply_depositor_metadata(RH_CONFIG["depositor"])
      ev.datastreams["mediaInfo"].ng_xml = ng_info
      # apply additional tech data from gbv xml
      update_preservation_fields(ev) if type == "preservation"
      update_access_fields(ev) if type == "access"
      ev.vendor = "George Blood Audio and Video"
      @parent.external_videos << ev
      @parent.save
      ev.save
    rescue Exception=>e
      raise "Failed to add #{type} datastream: #{e}"
    end
  end

  def update_preservation_fields(obj)
    # Instantiation fields
    obj.date                    = @sip.info(:p_create_date)             unless @sip.info(:p_create_date).nil?
    obj.condition               = @sip.info(:condition)                 unless @sip.info(:condition).nil?
    obj.cleaning                = @sip.info(:cleaning)                  unless @sip.info(:cleaning).nil?
    obj.file_format             = @sip.info(:p_file_format)             unless @sip.info(:p_file_format).nil?
    obj.capture_soft            = @sip.info(:capture_soft)              unless @sip.info(:capture_soft).nil?
    obj.operator                = @sip.info(:p_operator)                unless @sip.info(:p_operator).nil?
    obj.trans_note              = @sip.info(:p_trans_note)              unless @sip.info(:p_trans_note).nil?
    obj.device                  = @sip.info(:device)                    unless @sip.info(:device).nil?
    obj.chroma                  = @sip.info(:p_chroma)                  unless @sip.info(:p_chroma).nil?
    obj.color_space             = @sip.info(:p_color_space)             unless @sip.info(:p_color_space).nil?
    obj.duration                = @sip.info(:p_duration)                unless @sip.info(:p_duration).nil?
    obj.generation              = "Copy: preservation" 

    # Video essence track fields
    obj.video_standard          = @sip.info(:standard)                  unless @sip.info(:standard).nil?
    obj.video_encoding          = @sip.info(:p_video_codec)             unless @sip.info(:p_video_codec).nil?
    obj.video_bit_rate          = @sip.info(:p_video_bit_rate)          unless @sip.info(:p_video_bit_rate).nil?
    obj.video_bit_rate_units    = @sip.info(:p_video_bit_rate_units)    unless @sip.info(:p_video_bit_rate_units).nil?
    obj.video_bit_depth         = @sip.info(:p_video_bit_depth)         unless @sip.info(:p_video_bit_depth).nil?
    obj.frame_rate              = @sip.info(:p_frame_rate)              unless @sip.info(:p_frame_rate).nil?
    obj.frame_size              = @sip.info(:p_frame_size)              unless @sip.info(:p_frame_size).nil?
    obj.aspect_ratio            = @sip.info(:p_ratio)                   unless @sip.info(:p_ratio).nil?


    # Audio essence track fields
    obj.audio_standard          = @sip.info(:p_audio_standard)          unless @sip.info(:p_audio_standard).nil?
    obj.audio_encoding          = @sip.info(:p_audio_encoding)          unless @sip.info(:p_audio_encoding).nil?
    obj.audio_bit_rate          = @sip.info(:p_audio_bit_rate)          unless @sip.info(:p_audio_bit_rate).nil?
    obj.audio_bit_rate_units    = @sip.info(:p_audio_bit_rate_unit)			unless @sip.info(:p_audio_bit_rate_unit).nil?
    obj.audio_sample_rate       = @sip.info(:p_audio_sample_rate)       unless @sip.info(:p_audio_sample_rate).nil?
    obj.audio_sample_rate_units = @sip.info(:p_audio_sample_rate_unit)  unless @sip.info(:p_audio_sample_rate_unit).nil?
    obj.audio_bit_depth         = @sip.info(:p_audio_bit_depth)         unless @sip.info(:p_audio_bit_depth).nil?
    obj.audio_channels          = @sip.info(:p_audio_channels)          unless @sip.info(:p_audio_channels).nil?
  end

  def update_access_fields(obj)
    # Instantiation fields
    obj.date                    = @sip.info(:a_create_date)             unless @sip.info(:a_create_date).nil?
    obj.file_format             = @sip.info(:a_file_format)             unless @sip.info(:a_file_format).nil?
    obj.trans_soft              = @sip.info(:trans_soft)                unless @sip.info(:trans_soft).nil?
    obj.operator                = @sip.info(:a_operator)                unless @sip.info(:a_operator).nil?
    obj.trans_note              = @sip.info(:a_trans_note)              unless @sip.info(:a_trans_note).nil?
    obj.chroma                  = @sip.info(:a_chroma)                  unless @sip.info(:a_chroma).nil?
    obj.color_space             = @sip.info(:a_color_space)             unless @sip.info(:a_color_space).nil?
    obj.duration                = @sip.info(:a_duration)                unless @sip.info(:a_duration).nil?
    obj.generation              = "Copy: access"

    # Video essence track fields
    obj.video_standard          = @sip.info(:standard)                  unless @sip.info(:standard).nil?
    obj.video_encoding          = @sip.info(:a_video_codec)             unless @sip.info(:a_video_codec).nil?
    obj.video_bit_rate          = @sip.info(:a_video_bit_rate)          unless @sip.info(:a_video_bit_rate).nil?
    obj.video_bit_rate_units    = @sip.info(:a_video_bit_rate_units)    unless @sip.info(:a_video_bit_rate_units).nil?
    obj.video_bit_depth         = @sip.info(:a_video_bit_depth)         unless @sip.info(:a_video_bit_depth).nil?
    obj.frame_rate              = @sip.info(:a_frame_rate)              unless @sip.info(:a_frame_rate).nil?
    obj.frame_size              = @sip.info(:a_frame_size)              unless @sip.info(:a_frame_size).nil?
    obj.aspect_ratio            = @sip.info(:a_ratio)                   unless @sip.info(:a_ratio).nil?

    # Audio essence track fields
    obj.audio_standard          = @sip.info(:a_audio_standard)          unless @sip.info(:a_audio_standard).nil?
    obj.audio_encoding          = @sip.info(:a_audio_encoding)          unless @sip.info(:a_audio_encoding).nil?
    obj.audio_bit_rate          = @sip.info(:a_audio_bit_rate)          unless @sip.info(:a_audio_bit_rate).nil?
    obj.audio_bit_rate_units    = @sip.info(:a_audio_bit_rate_unit)			unless @sip.info(:a_audio_bit_rate_unit).nil?
    obj.audio_sample_rate       = @sip.info(:a_audio_sample_rate)			  unless @sip.info(:a_audio_sample_rate).nil?
    obj.audio_sample_rate_units = @sip.info(:a_audio_sample_rate_unit)  unless @sip.info(:a_audio_sample_rate_unit).nil?
    obj.audio_bit_depth         = @sip.info(:a_audio_bit_depth)         unless @sip.info(:a_audio_bit_depth).nil?
    obj.audio_channels          = @sip.info(:a_audio_channels)          unless @sip.info(:a_audio_channels).nil?
  end


end
end
