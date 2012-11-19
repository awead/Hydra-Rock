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
    raise "Specified path does not exist" unless File.exists?(path)
    self.root = path
    self.base = File.basename(path)
  end

  def valid?(errors = Array.new)
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

  def prepare(opts={})
    raise "XML barcode does not match folder name" unless barcodes_match?
    raise "Pid already exists"                     if self.pid
    raise "Invalid sip"                            unless self.valid?
    raise "Can't write to root directory of sip"   unless File.writable?(File.dirname(self.root))

    begin
      @av = ArchivalVideo.new
      @av.save
      @av.label = "George Blood Audio and Video"
      self.update_fields
      @av.save
    rescue Exception=>e
      raise "Failed create new video object: #{e}"
    end

    # Rename sip using the new object pid
    begin
      new_name = @av.pid.gsub(/:/,"_")
      FileUtils.mv self.root, File.join(File.dirname(self.root), new_name)
      self.base = new_name
      self.root = File.join(File.dirname(self.root), new_name)
    rescue Exception=>e
      raise "Failed to rename sip with PID: #{e}"
    end

  end

  # Prepares a sip resuing the pid provided by the directory name
  def reuse
    raise "Invalid pid format used in base directory name" unless self.base.match(/^#{RH_CONFIG["pid_space"]}_/)
    raise "Invalid sip"                                    unless self.valid?

    begin
      @av = ArchivalVideo.new({:pid=>self.base.gsub(/_/,":")})
      self.update_fields
      @av.save
    rescue Exception=>e
      raise "Failed create new video object: #{e}"
    end
  end

  def doc
    file  = File.join(self.root, "*.xml")
    files = Dir.glob(file)
    Workflow::GbvDocument.from_xml(File.new(files.first)) if files.length > 0
  end

  # grab fields from GBV xml file as defined in Workflow::GbvDocument
  def info(field)
    self.doc.send(field.to_sym) unless self.doc.nil?
  end

  # barcode is requried so it gets its own method
  def barcode
    self.doc.barcode unless self.doc.nil?
  end

  # title is required so it gets its own method
  def title
    self.doc.title unless self.doc.nil?
  end

  def access
    file  = File.join(self.root, "data", "*_access.mp4")
    files = Dir.glob(file)
    File.basename(files.first) if files.length == 1
  end

  def preservation
    file  = File.join(self.root, "data", "*_preservation.mov")
    files = Dir.glob(file)
    File.basename(files.first) if files.length == 1
  end

  def pid
    return nil unless self.barcode
    obj = ArchivalVideo.find("barcode_t" => self.barcode)
    if obj.empty?
      return nil
    elsif obj.length == 1
      return obj.first.pid
    else
      raise "Barcode search returned more than one document, when there should be only 0 or 1"
    end
  end

  def barcodes_match?
   self.barcode == self.base ? true : false
  end

  def update_fields
    @av.barcode       = self.barcode
    @av.main_title    = self.title
    @av.creation_date = self.info(:orig_date) unless self.info(:orig_date).nil?
    @av.standard      = self.info(:standard)  unless self.info(:standard).nil?
    @av.format        = self.info(:format)    unless self.info(:format).nil?
  end

end
end