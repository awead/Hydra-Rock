# SIPs from George Blood
#
# These are not cataloged in Hydra yet, so they have no pids
#
# Usage:
# > path = "[path_to_sip]" --> full path is preferable
# > sip = GeorgeBloodVideoSip.new(path)
# > sip.valid?
# => true
# ---------------------------------------------------------------
module Workflow
class GbvSip

  include Rockhall::WorkflowMethods

  attr_accessor :root, :base

  def initialize(path)
    unless File.exists?(path)
      raise "Specified path does not exist"
    end
    self.root = path
    self.base = File.basename(path)
  end

  def valid?
    errors = Array.new
    # Check required fields
    errors << "No barcode found"     unless self.barcode
    errors << "Title not found"      unless self.title
    errors << "No access file"       unless self.access
    errors << "No preservation file" unless self.preservation

    if errors.length > 0
      logger.info("SIP #{self.base} in invalid: #{errors.join(" -- ")}")
      return false
    else
      logger.info("SIP #{self.base} is valid")
      return true
    end
  end

  def prepare
    return false if self.pid
    return false unless self.valid?

    # Create new video object
    begin
      av = ArchivalVideo.new
      ds = av.datastreams_in_memory["descMetadata"]
      ds.update_indexed_attributes( {[:item, :barcode] => {"0" => self.barcode}} )
      ds.update_indexed_attributes( {[:full_title]     => {"0" => self.title}} )
      av.save
    rescue Exception=>e
      raise "Failed create new video object: #{e}"
    end

    # Rename sip using object pid
    new_name = av.pid.gsub(/:/,"_")
    FileUtils.mv self.root, File.join(File.dirname(self.root), new_name)
    self.base = new_name
    self.root = File.join(File.dirname(self.root), new_name)

  end

  def doc
    file  = File.join(self.root, "*.xml")
    files = Dir.glob(file)
    if files.length > 0
      doc = Workflow::GbvDocument.from_xml(File.new(files.first))
    end
  end

  def barcode
    unless self.doc.nil?
      return self.doc.barcode
    end
  end

  def title
    unless self.doc.nil?
      return self.doc.title
    end
  end

  def access
    file  = File.join(self.root, "data", "*_access.mp4")
    files = Dir.glob(file)
    if files.length == 1
      return File.basename(files.first)
    end
  end

  def preservation
    file  = File.join(self.root, "data", "*_preservation.mov")
    files = Dir.glob(file)
    if files.length == 1
      return File.basename(files.first)
    end
  end

  def pid
    return nil unless self.barcode
    solr_params = { :fl => "id", :q  => "item_barcode_t:#{self.barcode}", :qt => "document" }
    solr_response = Blacklight.solr.find(solr_params)
    if solr_response[:response][:numFound] == 0
      return nil
    elsif solr_response[:response][:numFound] == 1
      return solr_response[:response][:docs][0][:id]
    else
      raise "Barcode search returned more than one document, when there should be only 0 or 1"
    end
  end

end
end