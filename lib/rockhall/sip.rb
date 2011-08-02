# Submission information package class
#
# Defines a SIP as folder with files inside.  Each file corresponds or relates to a datastream
# defined in a content model.
#
# ==Sample usage
#
# >> path = Dir.new("path/to/SIP")
# >> sip = Rockhall::Sip.new
# >> sip.add_package(path)
# >> sip.valid?
# => true
# >> sip.store
# >> sip = Rockhall::Sip.load(path)


module Rockhall
class Sip

  attr_accessor :root, :pid, :preservation, :access_hq, :access_lq, :status

  INFOFILE = "info.dat"

  def initialize(object_attribute_hash={})
  end

  def self.load(path)
    unless File.exists?(File.join(path, INFOFILE))
      raise "No data file. Are you sure this is a saved SIP?"
    end
    datafile = File.new(File.join(path, INFOFILE))
    sip = Marshal.load(datafile)

    if path != sip.root
      logger.warn("Warning: SIP path has changed")
      sip.root == path
    end
    return sip
  end

  def add(path,opts={})
    document = ActiveFedora::Base.load_instance(File.basename(path).to_s.sub(/_/,":"))
    unless document.relationships[:self][:has_model].first == "info:fedora/afmodel:ArchivalVideo"
      raise "Wrong content type"
    end
    @pid = document.pid
    @root = path
    self.valid?
  end

  def store(opts={})
    marshal_dump = Marshal.dump(self)
    file = File.new(File.join(@root, INFOFILE), 'w')
    file.write marshal_dump
    file.close
    return true
  end

  def valid?
    files = Dir.entries(self.root)
    files.each do |f|
      return false unless valid_file?(f)
      self.preservation = f if is_preservation?(f)
      self.access_hq = f if is_access_hq?(f)
      self.access_lq = f if is_access_lq?(f)
    end
    return true
  end

  private

  def valid_file?(name)
    parts = name.split(/_/)
    if File.extname(name) == ".avi"
      #return false unless parts[0] == "rrhof"
      return true
    end
    return true
  end

  def is_access_hq?(name)
    return true if name == "rrhof_access_h264_high.avi"
  end

  def is_access_lq?(name)
    return true if name == "rrhof_access_h264_low.avi"
  end

  def is_preservation?(name)
    return true if name == "rrhof_preservation_10bit.avi"
  end

end
end
