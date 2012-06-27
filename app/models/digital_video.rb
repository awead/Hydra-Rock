class DigitalVideo < ActiveFedora::Base

  include Hydra::ModelMethods
  include Rockhall::ModelMethods
  include Rockhall::WorkflowMethods
  include Hydra::SubmissionWorkflow
  include ActiveFedora::FileManagement
  include ActiveFedora::Relationships
  include ActiveFedora::DatastreamCollections

  after_create :apply_default_permissions

  has_relationship "objects", :is_part_of, :inbound => true

  has_metadata :name => "rightsMetadata", :type => Hydra::Datastream::RightsMetadata
  has_metadata :name => "descMetadata",   :type => Rockhall::PbcoreDigitalDocument
  has_metadata :name => "properties",     :type => Rockhall::Properties
  has_metadata :name => "assetReview",    :type => Rockhall::AssetReview

  delegate_to :assetReview,
    [:reviewer, :date_updated, :complete, :priority, :license, :abstract]

  delegate_to :descMetadata,
    [:main_title, :alternative_title, :chapter, :episode, :segment, :subtitle, :track,
     :translation, :lc_subject, :lc_name, :rh_subject, :subjects, :summary, :parts_list,
     :getty_genre, :lc_genre, :lc_subject_genre, :genres, :event_series, :event_place,
     :event_date, :contributor_name, :contributor_role, :publisher_name, :publisher_role,
     :note, :archival_collection, :archival_series, :collection_number, :accession_number,
     :usage]

  delegate :title_label, :to=> :descMetadata, :at=>[:label]

  delegate_to :properties, [:depositor, :notes]

end
