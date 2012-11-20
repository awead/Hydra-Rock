# Rockhall SIPs
#
# Very generic content containers in BagIt form. We define one access file and multiple
# preservation files.
#
# Usage:
# > path = "[path_to_sip]" --> full path is preferable
# > sip = RockhallSip.new(path)
# > sip.valid?
# => true
# ---------------------------------------------------------------
module Workflow
class RockhallSip

  include Rockhall::WorkflowMethods

  attr_accessor :root, :base

  def initialize(path)
    raise "Specified path does not exist" unless File.exists?(path)
    self.root = path
    self.base = File.basename(path)
  end

  def valid?
    errors = Array.new
    # Check required fields
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

  # Prepares a sip for ingestion
  def prepare
    raise "Invalid sip" unless self.valid?
    if self.pid
      update
    else
      create
    end
  end

  # Prepares a sip resuing the pid provided by the directory name
  # You should use this if the object is deleted from Fedora but
  # you still have the sip and want to recreated the object using
  # its original pid.
  def reuse
    raise "Invalid pid format used in base directory name" unless self.base.match(/^#{RH_CONFIG["pid_space"]}_/)
    raise "Invalid sip"                                    unless self.valid?

    begin
      dv = DigitalVideo.new({:pid=>self.base.gsub(/_/,":")})
      dv.save
    rescue Exception=>e
      raise "Failed create new video object: #{e}"
    end
  end

  def access(results = Array.new)
    files = Dir.glob(File.join(self.root, "data", "*_access.mp4")).each do |file|
      results << File.basename(file)
    end
    results.empty? ? nil : results.sort
  end

  def next_access(file)
    next_index = self.get_next(self.access.index(file), self.access.length)
    self.access[next_index] unless next_index.nil?
  end

  def previous_access(file)
    previous_index = self.get_previous(self.access.index(file), self.access.length)
    self.access[previous_index] unless previous_index.nil?
  end

  def preservation(results = Array.new) 
    Dir.glob(File.join(self.root, "data", "*_preservation.mov")).each do |file|
      results << File.basename(file)
    end
    results.empty? ? nil : results.sort
  end

  def next_preservation(file)
    next_index = self.get_next(self.preservation.index(file), self.preservation.length)
    self.preservation[next_index] unless next_index.nil?
  end

  def previous_preservation(file)
    previous_index = self.get_previous(self.preservation.index(file), self.preservation.length)
    self.preservation[previous_index] unless previous_index.nil?
  end

  def pid
    begin
      ArchivalVideo.find(self.base.sub(/_/,":")).pid
    rescue
      nil
    end
  end

  private

  # Creates a new sip from a given directory
  def create(opts={})
    raise "Can't write to root directory of sip" unless File.writable?(File.dirname(self.root))
    begin
      dv = DigitalVideo.new
      dv.main_title = self.base.to_s
      dv.save
      dv.label = "Rock and Roll Hall of Fame Library and Archives"
      dv.save
    rescue Exception=>e
      raise "Failed create new video object: #{e}"
    end

    # Rename sip using the new object pid
    begin
      new_name = dv.pid.gsub(/:/,"_")
      FileUtils.mv self.root, File.join(File.dirname(self.root), new_name)
      self.base = new_name
      self.root = File.join(File.dirname(self.root), new_name)
    rescue Exception=>e
      raise "Failed to rename sip with PID: #{e}"
    end

  end

  # Updates a sip if the parent object was previously created
  def update
    begin
      dv = DigitalVideo.find(self.pid)
      dv.label = "Rock and Roll Hall of Fame Library and Archives"
      dv.save
    rescue Exception=>e
      raise "Failed update video object: #{e}"
    end
  end


end
end