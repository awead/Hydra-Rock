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
  has_metadata :name => "descMetadata",   :type => Rockhall::PbcoreInstantiation
  has_metadata :name => "mediaInfo",      :type => MediainfoXml::Document
  has_metadata :name => "properties",     :type => Rockhall::Properties

  delegate :name,                    :to => :descMetadata
  delegate :location,                :to => :descMetadata
  delegate :date,                    :to => :descMetadata
  delegate :generation,              :to => :descMetadata
  delegate :media_type,              :to => :descMetadata
  delegate :file_format,             :to => :descMetadata
  delegate :size,                    :to => :descMetadata
  delegate :size_units,              :to => :descMetadata
  delegate :colors,                  :to => :descMetadata
  delegate :duration,                :to => :descMetadata
  delegate :rights_summary,          :to => :descMetadata
  delegate :note,                    :to => :descMetadata
  delegate :checksum_type,           :to => :descMetadata
  delegate :checksum_value,          :to => :descMetadata
  delegate :device,                  :to => :descMetadata
  delegate :capture_soft,            :to => :descMetadata
  delegate :trans_soft,              :to => :descMetadata
  delegate :operator,                :to => :descMetadata
  delegate :trans_note,              :to => :descMetadata
  delegate :vendor,                  :to => :descMetadata
  delegate :condition,               :to => :descMetadata
  delegate :cleaning,                :to => :descMetadata
  delegate :color_space,             :to => :descMetadata
  delegate :chroma,                  :to => :descMetadata
  delegate :standard,                :to => :descMetadata
  delegate :language,                :to => :descMetadata
  delegate :video_standard,          :to => :descMetadata
  delegate :video_encoding,          :to => :descMetadata
  delegate :video_bit_rate,          :to => :descMetadata
  delegate :video_bit_rate_units,    :to => :descMetadata
  delegate :frame_rate,              :to => :descMetadata
  delegate :frame_size,              :to => :descMetadata
  delegate :video_bit_depth,         :to => :descMetadata
  delegate :aspect_ratio,            :to => :descMetadata
  delegate :audio_standard,          :to => :descMetadata
  delegate :audio_encoding,          :to => :descMetadata
  delegate :audio_bit_rate,          :to => :descMetadata
  delegate :audio_bit_rate_units,    :to => :descMetadata
  delegate :audio_sample_rate,       :to => :descMetadata
  delegate :audio_sample_rate_units, :to => :descMetadata
  delegate :audio_bit_depth,         :to => :descMetadata
  delegate :audio_channels,          :to => :descMetadata
  delegate :next,                    :to => :descMetadata
  delegate :previous,                :to => :descMetadata
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
      obj = ExternalVideo.load_instance(pid)
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
