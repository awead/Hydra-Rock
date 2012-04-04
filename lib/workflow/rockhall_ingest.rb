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

    # Process each access file
    @sip.access.each do |aces|
      ev = self.ingest(@sip.base, aces, "access", {:format=>"h264"} )
      ev.generation = "Copy: access"
      if @sip.next_access(aces)
        ev.datastreams["descMetadata"].insert_node("next", {:root => "pbcoreInstantiation"})
        ev.next = @sip.next_access(aces).to_s
      end
      if @sip.previous_access(aces)
        ev.datastreams["descMetadata"].insert_node("previous", {:root => "pbcoreInstantiation"})
        ev.previous = @sip.previous_access(aces).to_s
      end
      ev.save
    end

    # Process each preservation file
    @sip.preservation.each do |pres|
      ev = self.ingest(@sip.base, pres, "preservation", {:format=>"original"} )
      ev.generation = "original"
      if @sip.next_preservation(pres)
        ev.datastreams["descMetadata"].insert_node("next", {:root => "pbcoreInstantiation"})
        ev.next = @sip.next_preservation(pres).to_s
      end
      if @sip.previous_preservation(pres)
        ev.datastreams["descMetadata"].insert_node("previous", {:root => "pbcoreInstantiation"})
        ev.previous = @sip.previous_preservation(pres).to_s
      end
      ev.save
    end
  end

  # parent object exists in Fedora and has child objects that need to be reingested
  def reprocess(opts={})
    @parent.remove_file_objects unless @parent.file_objects.empty?
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
      ev.save
      ds = ev.datastreams["descMetadata"]
      opts[:format].nil? ? ev.label = "unknown" : ev.label = opts[:format]
      ev.add_named_datastream(type, :label=>file, :dsLocation=>location, :directory=>directory )
      ev.apply_depositor_metadata(RH_CONFIG["depositor"])
      ev.datastreams["mediaInfo"].ng_xml = ng_info
      ev.vendor = "Rock and Roll Hall of Fame Library and Archives"
      ev.date = mtime
      @parent.file_objects_append(ev)
      @parent.save
    rescue Exception=>e
      raise "Failed to add #{type} datastream: #{e}"
    end
    return ev
  end

end
end
