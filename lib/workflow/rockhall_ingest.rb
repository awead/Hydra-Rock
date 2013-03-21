require 'mediainfo'

module Workflow
class RockhallIngest

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

    # Process each access file
    @sip.access.each do |a|
      ev = self.ingest(@sip.base, a, "access", {:format=>"h264"} )
      ev.generation = "Copy: access"
      ev.datastreams["descMetadata"].insert_next(@sip.next_access(a).to_s)         if @sip.next_access(a)
      ev.datastreams["descMetadata"].insert_previous(@sip.previous_access(a).to_s) if @sip.previous_access(a)
      ev.save
    end

    # Process each preservation file
    @sip.preservation.each do |p|
      ev = self.ingest(@sip.base, p, "preservation", {:format=>"original"} )
      ev.generation = "original"
      ev.datastreams["descMetadata"].insert_next(@sip.next_preservation(p).to_s)         if @sip.next_preservation(p)
      ev.datastreams["descMetadata"].insert_previous(@sip.previous_preservation(p).to_s) if @sip.previous_preservation(p)
      ev.save
    end

    # add a thumbnail
    begin
      generate_video_thumbnail(File.join(RH_CONFIG["location"], @sip.base, "data", @sip.access.first))
      thumb = File.new("tmp/thumb.jpg")
      @parent.add_thumbnail thumb
    rescue
      puts "INFO: Failed to add thumbnail image"
    end
  end

  # parent object exists in Fedora and has child objects that need to be reingested
  def reprocess(opts={})
    @parent.remove_external_videos unless @parent.external_videos.empty?
    video = ArchivalVideo.find(self.sip.pid)
    @parent = video
    self.process
  end

  def ingest(base,file,type,opts={})
    # Point to file locations in the BagIt bag
    location  = File.join(RH_CONFIG["host"], base, "data", file)
    directory = File.join(RH_CONFIG["location"], base, "data")
    mtime = parse_date(File.new(File.join(directory, file)).mtime.to_s)

    # Get tech data using MediaInfo
    info      = Mediainfo.new File.join(directory, file)
    ng_info   = Nokogiri::XML::Document.parse(info.raw_response)

    begin
      ev = ExternalVideo.new
      ev.define_digital_instantiation
      ev.save
      ds = ev.datastreams["descMetadata"]
      opts[:format].nil? ? ev.label = "unknown" : ev.label = opts[:format]
      ev.add_named_datastream(type, :label=>file, :dsLocation=>location, :directory=>directory )
      ev.apply_depositor_metadata(RH_CONFIG["depositor"])
      ev.datastreams["mediaInfo"].ng_xml = ng_info
      ev.vendor = "Rock and Roll Hall of Fame Library and Archives"
      ev.date = mtime
      @parent.external_videos << ev
      @parent.save
      ev.save
    rescue Exception=>e
      raise "Failed to add #{type} datastream: #{e}"
    end
    return ev
  end

end
end
