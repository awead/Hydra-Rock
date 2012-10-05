class ArchivalVideo < ActiveFedora::Base

  # This a working model used for storing video objects in Fedora.  Comments above each
  # section below explain the elements at work.  A more general example of creating models
  # in Hydra can be found here:
  #
  #  https://github.com/projecthydra/hydra-head/wiki/Models---Defining-a-Custom-Hydra-Model
  #
  # Many of the modeling strategies used here are also outlined in the above page that
  # describes creating a custom model in a more general fashion.

  # These are include statement that mix in other functions referenced in other
  # libraries.  The libraries come from the ActiveFedora gem, Hydra and our own
  # local Rockhall libraries.  You can mix in model methods from any gem or library,
  # such as ActiveModel.  The extent of the mixins is completely up to your own needs.
  include ActiveFedora::DatastreamCollections
  include ActiveFedora::FileManagement
  include ActiveFedora::Relationships
  include Hydra::ModelMethods
  #include Hydra::SubmissionWorkflow
  include Rockhall::ModelMethods
  include Rockhall::WorkflowMethods
  include ActiveModel::Validations
  include Rockhall::Validations

  # ActiveFedora implements callbacks just like ActiveRecord does and you can specify
  # them here.  #apply_default_permissions is a particular method in our local Rockhall
  # library, which is found in Rockhall::ModelMethods.
  after_create :apply_default_permissions

  # Fedora relationships between objects that are found in the RELS-EXT datastream are
  # defined here. By including the ActiveFedora::Relationships mixin above, we can use any
  # of the standard Fedora relationships to link our objects together.  For more
  # information on using these relationships, see the documentation on ActiveFedora. Here,
  # we use the AchivalVideo object to act as a parent object to which other objects can
  # assert an "isPartOf" relationship.  The fact that it is "inbound" means that the
  # relationship is incoming from another object, like inbound traffic coming in from
  # somewhere.
  has_relationship "objects", :is_part_of, :inbound => true

  # This is the essential "meat" section of our model where we actually define which
  # datastreams are in our objects and what's in them.  The name of the datastream is
  # how it will appear in the object's FOXML, the type refers to its content.  The
  # datastreams listed below are all xml datastreams that use an OM terminology to
  # define their terms.
  has_metadata :name => "rightsMetadata", :type => Hydra::Datastream::RightsMetadata
  has_metadata :name => "descMetadata",   :type => Rockhall::PbcoreDocument
  has_metadata :name => "properties",     :type => Rockhall::Properties
  has_metadata :name => "assetReview",    :type => Rockhall::AssetReview

  # We use the delegate_to method link term definitions and their datastreams to our
  # model's attributes.
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
