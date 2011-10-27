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

  def process(opts={})
    if opts[:force]
      @parent.remove_file_objects unless @parent.file_objects.empty?
    end
    self.ingest(@sip.base, @sip.access,       "access",       {:format=>"h264"})     unless @parent.videos[:h264]
    self.ingest(@sip.base, @sip.preservation, "preservation", {:format=>"original"}) unless @parent.videos[:original]
  end

  def ingest(base,file,type,opts={})

    # Point to file locations in the BagIt bag
    location  = File.join(Blacklight.config[:video][:host], base, "data", file)
    directory = File.join(Blacklight.config[:video][:location], base, "data")

    begin
      ev = ExternalVideo.new
      opts[:format].nil? ? ev.label = "unknown" : ev.label = opts[:format]
      ev.add_named_datastream(type, :label=>file, :dsLocation=>location, :directory=>directory )
      ev.apply_depositor_metadata(Blacklight.config[:video][:depositor])
      @parent.file_objects_append(ev)
      @parent.save
    rescue Exception=>e
      raise "Failed to add #{type} datastream: #{e}"
    end
  end

end
end