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

  attr_accessor :info, :data

  # :root, :preservation, :access, :xml, :barcode, :title

  def initialize(path)
    unless File.exists?(path)
      raise "Specified path does not exist"
    end

    @info = {
      :root    => path,
      :barcode => File.basename(path),
      :xml     => get_file(File.join(path, "#{File.basename(path)}.xml"))
    }

    # Define our data structure
    @data = {
      :access => {
        :h264 => {
          :file     => get_file(File.join(@info[:root], "#{@info[:barcode]}_access.avi")),
          :checksum => get_checksum(File.join(@info[:root], "#{@info[:barcode]}_access.avi.sha"))
        }
      },
      :preservation => {
        :original => {
          :file     => get_file(File.join(@info[:root], "#{@info[:barcode]}_pres.avi")),
          :checksum => get_checksum(File.join(@info[:root], "#{@info[:barcode]}_pres.avi.sha"))
        }
      }
    }

  end

  def valid?

    errors = Array.new

    # Check file contents
    errors << "H264 file is missing" if self.data[:access][:h264][:file].nil?
    errors << "No checksum for H264 file" if self.data[:access][:h264][:checksum].nil?
    errors << "Original preservation file is missing" if self.data[:preservation][:original][:file].nil?
    errors << "No checksum for original preservation file" if self.data[:preservation][:original][:checksum].nil?

    # Check required fields
    errors << "Barcode does not match xml" unless self.has_barcode?
    errors << "Title not found" unless self.has_title?
    errors << "Incorrect number of files detected" unless Dir.new(self.info[:root]).entries.count == 7 # because "." and ".." count as entries

    if errors.length > 0
      logger.info("SIP in invalid: #{errors.join(" -- ")}")
      return false
    else
      logger.info("SIP is valid")
      return true
    end
  end

  def doc
    file = File.new(File.join(self.info[:root], self.info[:xml]))
    doc = Rockhall::PbcoreDocument.from_xml(file)
  end

  def has_barcode?
    unless self.info[:xml].nil?
      if self.doc.get_values([:item, :barcode]).first == self.info[:barcode]
        return true
      else
        return false
      end
    end
  end

  def has_title?
    unless self.info[:xml].nil?
      if self.doc.get_values([:full_title]).length > 0
        self.info[:title] = self.doc.get_values([:full_title]).first
        return true
      else
        return false
      end
    end
  end

  def pid
    solr_params = Hash.new
    solr_params[:fl] = "id"
    solr_params[:q]  = "item_barcode_t:#{self.info[:barcode]}"
    solr_params[:qt] = "document"
    solr_response = Blacklight.solr.find(solr_params)
    if solr_response[:response][:numFound] == 0
      return nil
    elsif solr_response[:response][:numFound] == 1
      return solr_response[:response][:docs][0][:id]
    else
      raise "Search returned more than one document, when there should be only 0 or 1"
    end
  end

end
end