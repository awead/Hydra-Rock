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
    unless File.exists?(path)
      raise "Specified path does not exist"
    end
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

  def prepare(opts={})
    if self.pid
      raise "Pid already exists"
    end
    raise "Invalid sip" unless self.valid?

    begin
      av = DigitalVideo.new
      av.save
      av.label = "Rock and Roll Hall of Fame Library and Archives"
      av.save
    rescue Exception=>e
      raise "Failed create new video object: #{e}"
    end

    # Rename sip using the new object pid
    begin
      new_name = av.pid.gsub(/:/,"_")
      FileUtils.mv self.root, File.join(File.dirname(self.root), new_name)
      self.base = new_name
      self.root = File.join(File.dirname(self.root), new_name)
    rescue Exception=>e
      raise "Failed to rename sip with PID: #{e}"
    end

  end

  # Prepares a sip resuing the pid provided by the directory name
  def reuse
    unless self.base.match(/^#{RH_CONFIG["pid_space"]}_/)
      raise "Invalid pid format used in base directory name"
    end
    raise "Invalid sip" unless self.valid?

    begin
      av = ArchivalVideo.new({:pid=>self.base.gsub(/_/,":")})
      ds = av.datastreams["descMetadata"]
      self.update_fields(ds)
      av.save
    rescue Exception=>e
      raise "Failed create new video object: #{e}"
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
    results = Array.new
    files.each do |file|
      results << File.basename(file)
    end
    return results
  end

  def pid
    pid = self.base.sub(/_/,":") # replaces first occurance only
    solr_params = { :fl => "id", :q  => "id:\"#{pid}\"", :qt => "document" }
    solr_response = Blacklight.solr.find(solr_params)
    if solr_response[:response][:numFound] == 0
      return nil
    else solr_response[:response][:numFound] == 1
      return solr_response[:response][:docs][0][:id]
    end
  end

end
end