require 'mediainfo'

module Workflow
class RockhallIngest

  include Rockhall::WorkflowMethods

  attr_accessor :parent, :sip, :force

  def initialize(sip,opts={})
    raise "Invalid sip" unless sip.valid?
    raise "SIP has no PID.  Did you prepare it?" if sip.pid.nil?
    @sip = sip
    @parent = DigitalVideo.load_instance(sip.pid)
  end

  # runs the first time to process a new sip that doesn't exist in Fedora
  def process(opts={})
    self.ingest(@sip.base, @sip.access,       "access",       {:format=>"h264"}) unless @parent.videos[:h264]
    @sip.preservation.each do |pres|
      self.ingest(@sip.base, pres, "preservation", {:format=>"original"})
    end
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
    p_ds = av.datastreams["descMetadata"]
    p_ds.update_indexed_attributes( {[:barcode]       => {"0" => @sip.barcode}} )
    p_ds.update_indexed_attributes( {[:main_title]    => {"0" => @sip.title}} )
    p_ds.update_indexed_attributes( {[:creation_date] => {"0" => @sip.info(:orig_date)}} ) unless @sip.info(:orig_date).nil?
    p_ds.update_indexed_attributes( {[:standard]      => {"0" => @sip.info(:standard)}} ) unless @sip.info(:standard).nil?
    p_ds.update_indexed_attributes( {[:format]        => {"0" => @sip.info(:format)}} ) unless @sip.info(:format).nil?
    av.save

    # Fields in preservation video object
    original = ExternalVideo.load_instance(av.videos[:original])
    o_ds = original.datastreams["descMetadata"]
    update_preservation_fields(o_ds)
    original.save

    # Fields in access video object
    access = ExternalVideo.load_instance(av.videos[:h264])
    a_ds = original.datastreams["descMetadata"]
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
      ev.save
      ds = ev.datastreams["descMetadata"]
      opts[:format].nil? ? ev.label = "unknown" : ev.label = opts[:format]
      ev.add_named_datastream(type, :label=>file, :dsLocation=>location, :directory=>directory )
      ev.apply_depositor_metadata(RH_CONFIG["depositor"])
      ev.datastreams["mediaInfo"].ng_xml = ng_info
      # apply additional tech data from gbv xml
      #update_preservation_fields(ds) if type == "preservation"
      #update_access_fields(ds) if type == "access"
      ds.update_indexed_attributes( {[:vendor] => {"0" => "Rock and Roll Hall of Fame Library and Archives"}} )
      @parent.file_objects_append(ev)
      @parent.save
    rescue Exception=>e
      raise "Failed to add #{type} datastream: #{e}"
    end
  end


end
end
