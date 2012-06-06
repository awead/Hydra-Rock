class ArchivalVideo < ActiveFedora::Base

  include ActiveFedora::DatastreamCollections
  include ActiveFedora::FileManagement
  include ActiveFedora::Relationships
  include Hydra::ModelMethods
  include Hydra::SubmissionWorkflow
  include Rockhall::ModelMethods
  include Rockhall::WorkflowMethods

  has_relationship "objects", :is_part_of, :inbound => true

  delegate :reviewer,             :to=> :assetReview
  delegate :date_updated,         :to=> :assetReview
  delegate :complete,             :to=> :assetReview
  delegate :priority,             :to=> :assetReview
  delegate :license,              :to=> :assetReview
  delegate :abstract,             :to=> :assetReview
  delegate :main_title,           :to=> :descMetadata
  delegate :alternative_title,    :to=> :descMetadata
  delegate :chapter,              :to=> :descMetadata
  delegate :episode,              :to=> :descMetadata
  delegate :label,                :to=> :descMetadata
  delegate :segment,              :to=> :descMetadata
  delegate :subtitle,             :to=> :descMetadata
  delegate :track,                :to=> :descMetadata
  delegate :translation,          :to=> :descMetadata
  delegate :lc_subject,           :to=> :descMetadata
  delegate :lc_name,              :to=> :descMetadata
  delegate :rh_subject,           :to=> :descMetadata
  delegate :subjects,             :to=> :descMetadata
  delegate :summary,              :to=> :descMetadata
  delegate :parts_list,           :to=> :descMetadata
  delegate :getty_genre,          :to=> :descMetadata
  delegate :lc_genre,             :to=> :descMetadata
  delegate :lc_subject_genre,     :to=> :descMetadata
  delegate :genres,               :to=> :descMetadata
  delegate :event_series,         :to=> :descMetadata
  delegate :event_place,          :to=> :descMetadata
  delegate :event_date,           :to=> :descMetadata
  delegate :contributor_name,     :to=> :descMetadata
  delegate :contributor_role,     :to=> :descMetadata
  delegate :publisher_name,       :to=> :descMetadata
  delegate :publisher_role,       :to=> :descMetadata
  delegate :note,                 :to=> :descMetadata
  delegate :creation_date,        :to=> :descMetadata
  delegate :barcode,              :to=> :descMetadata
  delegate :repository,           :to=> :descMetadata
  delegate :format,               :to=> :descMetadata
  delegate :standard,             :to=> :descMetadata
  delegate :media_type,           :to=> :descMetadata
  delegate :generation,           :to=> :descMetadata
  delegate :language,             :to=> :descMetadata
  delegate :colors,               :to=> :descMetadata
  delegate :archival_collection,  :to=> :descMetadata
  delegate :archival_series,      :to=> :descMetadata
  delegate :collection_number,    :to=> :descMetadata
  delegate :accession_number,     :to=> :descMetadata
  delegate :usage,                :to=> :descMetadata
  delegate :condition_note,       :to=> :descMetadata
  delegate :cleaning_note,        :to=> :descMetadata
  delegate :depositor,            :to=> :properties
  delegate :notes,                :to=> :properties

  has_metadata :name => "rightsMetadata", :type => Hydra::Datastream::RightsMetadata
  has_metadata :name => "descMetadata", :type => Rockhall::PbcoreDocument
  has_metadata :name => "properties", :type => Rockhall::Properties
  has_metadata :name => "assetReview", :type => Rockhall::AssetReview

  def initialize( attrs={} )
    super
    # Apply group permissions
    self.datastreams["rightsMetadata"].update_permissions( "group"=>{"archivist"=>"edit"} )
    self.datastreams["rightsMetadata"].update_permissions( "group"=>{"reviewer"=>"edit"} )
    self.datastreams["rightsMetadata"].update_permissions( "group"=>{"donor"=>"read"} )
  end

end
