class ExternalVideo < ActiveFedora::Base

  include ActiveFedora::DatastreamCollections
  include ActiveFedora::FileManagement
  include ActiveFedora::Relationships
  include Hydra::ModelMethods
  include Rockhall::ModelMethods

  after_create :apply_default_permissions

  has_relationship "is_member_of_collection", :has_collection_member, :inbound => true
  has_bidirectional_relationship "part_of", :is_part_of, :has_part

  # Object will have either an access or a perservation datastream but not both
  has_datastream :name=>"access",         :type=>ActiveFedora::Datastream, :controlGroup=>'E'
  has_datastream :name=>"preservation",   :type=>ActiveFedora::Datastream, :controlGroup=>'E'

  has_metadata :name => "rightsMetadata", :type => Hydra::Datastream::RightsMetadata
  has_metadata :name => "descMetadata",   :type => HydraPbcore::Datastream::Instantiation
  has_metadata :name => "mediaInfo",      :type => MediainfoXml
  has_metadata :name => "properties",     :type => Properties

  delegate_to :descMetadata,
    [ :name, :location, :date, :generation, :media_type, :file_format, :size, :size_units, :colors, 
      :duration, :rights_summary, :note, :checksum_type, :checksum_value, :device, :capture_soft, 
      :trans_soft, :operator, :trans_note, :vendor, :condition, :cleaning, :color_space, :chroma, 
      :standard, :language, :video_standard, :video_encoding, :video_bit_rate, :video_bit_rate_units, 
      :frame_rate, :frame_size, :video_bit_depth, :aspect_ratio, :audio_standard, :audio_encoding, 
      :audio_bit_rate, :audio_bit_rate_units, :audio_sample_rate, :audio_sample_rate_units, 
      :audio_bit_depth, :audio_channels, :next, :previous ]

  delegate :depositor,               :to => :properties
  delegate :notes,                   :to => :properties

  # augments add_named_datastream to put file information in descMetadata
  def add_named_datastream(name,opts={})
    super
    file = File.new(File.join(opts[:directory], opts[:label]))
    if file.respond_to?(:size)
      (size, units) = bits_to_human_readable(file.size)
    elsif file.kind_of?(File)
      (size, units) = bits_to_human_readable(File.size(file))
    else
      size = ""
      units = ""
    end
    self.size       = size
    self.size_units = size_units
    self.name       = opts[:label]
  end

  # deletes the object identified by pid if it does not have any objects asserting has_collection_member
  # Originally duplicated from FileAssets
  def self.garbage_collect(pid)
    begin
      obj = ExternalVideo.find(pid)
      if obj.containers.empty?
        obj.delete
      end
    rescue
    end
  end

  # @num file size in bits
  # Returns a human readable filesize and unit of measure (ie. automatically chooses 'bytes','KB','MB','GB','TB')
  # Based on a bit of python code posted here: http://blogmag.net/blog/read/38/Print_human_readable_file_size
  def bits_to_human_readable(num)
      ['bytes','KB','MB','GB','TB'].each do |x|
        if num < 1024.0
          return "#{num.to_i}", "#{x}"
        else
          num = num/1024.0
        end
      end
  end

end
