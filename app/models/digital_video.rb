class DigitalVideo < ActiveFedora::Base

  include Hydra::ModelMethods
  include Rockhall::ModelMethods
  include Rockhall::WorkflowMethods
  include ActiveFedora::FileManagement
  include ActiveFedora::Relationships
  include ActiveFedora::DatastreamCollections
  include Rockhall::Validations
  include ActiveModel::Validations
  include Rockhall::TemplateMethods
  include Rockhall::Conversion

  after_create :apply_default_permissions

  has_many :external_videos, :property => :is_part_of, :inbound => true

  has_metadata :name => "rightsMetadata", :type => Hydra::Datastream::RightsMetadata
  has_metadata :name => "descMetadata",   :type => HydraPbcore::Datastream::Deprecated::DigitalDocument
  has_metadata :name => "properties",     :type => Properties
  has_metadata :name => "assetReview",    :type => AssetReview

  has_file_datastream :name => "thumbnail", :type=>ActiveFedora::Datastream, :label => "Thumbnail image", :versionable => false

  delegate_to :assetReview,
    [:reviewer, :date_updated, :complete, :priority, :license, :abstract]

  delegate_to :descMetadata,
    [:alternative_title, :chapter, :episode, :segment, :subtitle, :track,
     :translation, :lc_subject, :lc_name, :rh_subject, :subject, :summary, :contents,
     :getty_genre, :lc_genre, :lc_subject_genre, :genre, :series, :event_place,
     :event_date, :contributor_name, :contributor_role, :publisher_name, :publisher_role,
     :note, :collection, :archival_series, :collection_number, :accession_number,
     :access]

  # Fields with only one value
  delegate :title, :to=> :descMetadata, :unique=>true
  validates_presence_of :title, :message => "Main title can't be blank"

  delegate :title_label, :to=> :descMetadata, :at=>[:label]

  delegate_to :properties, [:depositor, :notes]

  validate :validate_event_date

  # When exporting these objects to another index, we need to collect metadata from 
  # child objects such as ExternalVideos.  This method returns the standard .to_solr
  # hash and augments it with additional metadata from child objects.
  def to_discovery
    solr_doc = self.to_solr
    access_videos = Array.new
    self.videos[:access].each do |ev|
      access_videos << ev.name.first
    end
    solr_doc.merge!("access_file_s"      => access_videos)
    solr_doc.merge!("format_dtl_display" => self.videos[:access].first.mi_file_format)
    solr_doc.merge!("heading_display"    => self.title)
    solr_doc.merge!("material_facet"     => "Digital")
  end

end
