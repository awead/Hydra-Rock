class DigitalVideo < ActiveFedora::Base

  include Hydra::ModelMethods
  include Rockhall::ModelMethods
  include Rockhall::WorkflowMethods
  include Hydra::SubmissionWorkflow
  include ActiveFedora::FileManagement
  include ActiveFedora::Relationships
  include ActiveFedora::DatastreamCollections
  include Rockhall::Validations
  include ActiveModel::Validations
  include Rockhall::TemplateMethods

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

end
