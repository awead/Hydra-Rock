class ArchivalVideo < ActiveFedora::Base

  include ActiveFedora::DatastreamCollections
  include ActiveFedora::FileManagement
  include ActiveFedora::Relationships
  include Hydra::ModelMethods
  include Hydra::SubmissionWorkflow
  include Rockhall::ModelMethods
  include Rockhall::WorkflowMethods
  include ActiveModel::Validations
  include Rockhall::Validations

  after_create :apply_default_permissions

  has_relationship "objects", :is_part_of, :inbound => true

  has_metadata :name => "rightsMetadata", :type => Hydra::Datastream::RightsMetadata
  has_metadata :name => "descMetadata",   :type => Rockhall::PbcoreDocument
  has_metadata :name => "properties",     :type => Rockhall::Properties
  has_metadata :name => "assetReview",    :type => Rockhall::AssetReview

  delegate_to :assetReview,
    [:reviewer, :date_updated, :complete, :priority, :license, :abstract]

  delegate_to :descMetadata,
    [:alternative_title, :chapter, :episode, :segment, :subtitle, :track,
     :translation, :lc_subject, :lc_name, :rh_subject, :subjects, :summary, :parts_list,
     :getty_genre, :lc_genre, :lc_subject_genre, :genres, :event_series, :event_place,
     :event_date, :contributor_name, :contributor_role, :publisher_name, :publisher_role,
     :note, :creation_date, :barcode, :repository, :format, :standard, :media_type,
     :generation, :language, :colors, :archival_collection, :archival_series,
     :collection_number, :accession_number, :usage, :condition_note, :cleaning_note]

  # Fields with only one value
  delegate :main_title, :to=> :descMetadata, :unique=>true
  validates_presence_of :main_title, :message => "Main title can't be blank"

  # label is used for the Fedora object, so we have to call our label something else
  delegate :title_label, :to=> :descMetadata, :at=>[:label]

  delegate_to :properties, [:depositor, :notes]

  validate :validate_event_date
  validate :validate_creation_date

end
