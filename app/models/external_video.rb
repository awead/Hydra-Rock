class ExternalVideo < ActiveFedora::Base

  FieldList =
    [ :name, :location, :date, :generation, :media_type, :file_format, :size, :size_units, :colors, 
      :duration, :rights_summary, :note, :checksum_type, :checksum_value, :device, :capture_soft, 
      :trans_soft, :operator, :trans_note, :vendor, :condition, :cleaning, :color_space, :chroma, 
      :standard, :language, :video_standard, :video_encoding, :video_bit_rate, :video_bit_rate_units, 
      :frame_rate, :frame_size, :video_bit_depth, :aspect_ratio, :audio_standard, :audio_encoding, 
      :audio_bit_rate, :audio_bit_rate_units, :audio_sample_rate, :audio_sample_rate_units, 
      :audio_bit_depth, :audio_channels, :next, :previous, :barcode, :format, :depositor, :notes,
      :mi_file_format ]

  include Rockhall::ModelMethods
  include Rockhall::TemplateMethods
  include Rockhall::Conversion
  include Rockhall::Validations
  include Rockhall::Permissions

  after_create :apply_default_permissions

  belongs_to :parent, :property => :is_part_of, :class_name => "ArchivalVideo"

  # Object will have either an access or a perservation datastream but not both
  has_file_datastream :name => "access",         :type=>ActiveFedora::Datastream, :controlGroup=>'E'
  has_file_datastream :name => "preservation",   :type=>ActiveFedora::Datastream, :controlGroup=>'E'

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
      :audio_bit_depth, :audio_channels, :next, :previous, :barcode, :format ]

  delegate_to :properties, [:depositor, :notes]
  delegate :converted, :to => :properties, :unique => true    

  delegate :mi_file_format, :to => :mediaInfo

  validate :validate_date

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

  # TODO: this should go someplace else?
  def get_thumbnail_url
    nil
  end

  # Returns the name of the instatiation type based on the content of the :generation field
  def instantiation_type
    return nil if self.generation.empty?
    self.generation.first.match("Original") ? "physical" : "digital"
  end

  def to_solr solr_doc = Hash.new
    super(solr_doc)
    if self.parent.nil?
      solr_doc.merge!({"title_sort" => self.pid})
    else
      title_display = self.generation.first.nil? ? ("Video: " + self.parent.title) : (self.generation.first + ": " + self.parent.title)
      solr_doc.merge!({"title_display" => title_display})
      solr_doc.merge!({"title_sort" =>    title_display})
    end
    solr_doc.merge!({"media_format_facet" => self.format})

    self.date.each do |d|
      unless d.nil?
        solr_doc.merge!({"create_date_facet"  => Time.new(d).strftime("%Y")}) unless d.empty?
      end
    end

    self.language.each do |l|
      l.match(/^eng$/) ? solr_doc.merge!(:language_facet => "English") : solr_doc.merge!(:language_facet => "Unknown")
    end

    return solr_doc
  end

end
