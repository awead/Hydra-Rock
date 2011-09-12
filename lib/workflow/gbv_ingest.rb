module Workflow
class GbvIngest

  include Rockhall::WorkflowMethods

  attr_accessor :parent, :sip, :force

  def initialize(sip,opts={})
    @force = FALSE
    if sip.valid?
      @sip = sip
    else
      raise "Invalid sip"
    end

    if opts[:force]
      @force = TRUE
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

    src = File.join(@sip.info[:root], @sip.data[:access][:h264][:file])
    dst_name = new_name(@sip.pid,@sip.data[:access][:h264][:file],{ :type => ["access", "h264"] })
    dst = File.join(Blacklight.config[:video][:location], "access", dst_name)
    move_content(src,dst,{:force=>@force})
    @parent.ingest(dst_name,{:type=>"access",:format=>"h264"})

    src = File.join(@sip.info[:root], @sip.data[:preservation][:original][:file])
    dst_name = new_name(@sip.pid,@sip.data[:preservation][:original][:file],{ :type => ["preservation", "original"] })
    dst = File.join(Blacklight.config[:video][:location], "preservation", dst_name)
    move_content(src,dst,{:force=>@force})
    @parent.ingest(dst_name,{:format=>"original"})

    return true

  end



end
end