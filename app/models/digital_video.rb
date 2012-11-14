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

  after_create :apply_default_permissions

  has_relationship "objects", :is_part_of, :inbound => true

  has_metadata :name => "rightsMetadata", :type => Hydra::Datastream::RightsMetadata
  has_metadata :name => "descMetadata",   :type => HydraPbcore::Datastream::DigitalDocument
  has_metadata :name => "properties",     :type => Properties
  has_metadata :name => "assetReview",    :type => AssetReview

  delegate_to :assetReview,
    [:reviewer, :date_updated, :complete, :priority, :license, :abstract]

  delegate_to :descMetadata,
    [:alternative_title, :chapter, :episode, :segment, :subtitle, :track,
     :translation, :lc_subject, :lc_name, :rh_subject, :subjects, :summary, :parts_list,
     :getty_genre, :lc_genre, :lc_subject_genre, :genres, :event_series, :event_place,
     :event_date, :contributor_name, :contributor_role, :publisher_name, :publisher_role,
     :note, :archival_collection, :archival_series, :collection_number, :accession_number,
     :usage]

  # Fields with only one value
  delegate :main_title, :to=> :descMetadata, :unique=>true
  validates_presence_of :main_title, :message => "Main title can't be blank"

  delegate :title_label, :to=> :descMetadata, :at=>[:label]

  delegate_to :properties, [:depositor, :notes]

  validate :validate_event_date

end
