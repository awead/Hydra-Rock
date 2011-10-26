module Workflow
class GbvIngest

  include Rockhall::WorkflowMethods

  attr_accessor :parent, :sip, :force

  def initialize(sip,opts={})
    if opts[:force].nil?
      @force = FALSE
    else
      @force = TRUE
    end

    if sip.valid?
      @sip = sip
    elsif sip.info[:barcode]
      @sip = sip
    else
      raise "Invalid sip"
    end

    if @force
      av = ArchivalVideo.load_instance(sip.pid)
      av.remove_file_objects unless av.file_objects.empty?
      ActiveFedora::Base.load_instance(sip.pid).delete
    end

    if sip.pid.nil?
      @parent = ArchivalVideo.new
      ds = @parent.datastreams_in_memory["descMetadata"]
      ds.update_indexed_attributes( {[:item, :barcode] => {"0" => sip.info[:barcode]}} )
      ds.update_indexed_attributes( {[:full_title] => {"0" => sip.info[:title]}} )
      @parent.save
    else
      @parent = ArchivalVideo.load_instance(sip.pid)
    end
  end

  def process
    if self.sip.has_barcode?
      base = new_name(self.sip.pid,self.sip.info[:barcode])
      FileUtils.mv(File.join(Blacklight.config[:video][:location], self.sip.info[:barcode]), File.join(Blacklight.config[:video][:location], base))
    else
      base = sip.info[:barcode]
    end
    self.ingest(base,sip.info[:access],"access",{:format=>"h264"}) unless @parent.videos[:h264]
    self.ingest(base,sip.info[:preservation],"preservation",{:format=>"original"}) unless @parent.videos[:original]
    return true
  end

  def ingest(base,file,type,opts={})

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