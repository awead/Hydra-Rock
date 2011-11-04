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
    av.save

    # Fields in preservation video object
    original = ExternalVideo.load_instance(av.videos[:original])
    o_ds = original.datastreams_in_memory["descMetadata"]
    o_ds.update_indexed_attributes( {[:date]      => {"0" => @sip.info(:p_create_date)}} )  unless @sip.info(:p_create_date).nil?
    o_ds.update_indexed_attributes( {[:condition] => {"0" => @sip.info(:condition)}} )      unless @sip.info(:condition).nil?
    o_ds.update_indexed_attributes( {[:cleaning]  => {"0" => @sip.info(:cleaning)}} )       unless @sip.info(:cleaning).nil?
    o_ds.update_indexed_attributes( {[:vendor]    => {"0" => "George Blood Audio and Video"}} )
    original.save

    access = ExternalVideo.load_instance(av.videos[:h264])
    a_ds = original.datastreams_in_memory["descMetadata"]
    a_ds.update_indexed_attributes( {[:vendor] => {"0" => "George Blood Audio and Video"}} )
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
      if type == "preservation"
        ds.update_indexed_attributes( {[:date]      => {"0" => @sip.info(:p_create_date)}} )  unless @sip.info(:p_create_date).nil?
        ds.update_indexed_attributes( {[:condition] => {"0" => @sip.info(:condition)}} )      unless @sip.info(:condition).nil?
        ds.update_indexed_attributes( {[:cleaning]  => {"0" => @sip.info(:cleaning)}} )       unless @sip.info(:cleaning).nil?
      end
      # TODO: access file tech data? Date, I think, should be added...
      ds.update_indexed_attributes( {[:vendor] => {"0" => "George Blood Audio and Video"}} )
      @parent.file_objects_append(ev)
      @parent.save
    rescue Exception=>e
      raise "Failed to add #{type} datastream: #{e}"
    end


  end


end
end