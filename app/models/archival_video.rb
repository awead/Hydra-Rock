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
  include Rockhall::ModelMethods
  include Rockhall::WorkflowMethods
  include ActiveModel::Validations
  include Rockhall::Validations
  include Rockhall::TemplateMethods
  include Rockhall::Permissions

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
  has_many   :external_videos, :property => :is_part_of
  belongs_to :collection,      :property => :is_member_of_collection, :class_name => "ArchivalCollection"
  belongs_to :series,          :property => :is_member_of,            :class_name => "ArchivalComponent"

  # This is the essential "meat" section of our model where we actually define which
  # datastreams are in our objects and what's in them.  The name of the datastream is
  # how it will appear in the object's FOXML, the type refers to its content.  The
  # datastreams listed below are all xml datastreams that use an OM terminology to
  # define their terms.
  has_metadata :name => "rightsMetadata", :type => Hydra::Datastream::RightsMetadata
  has_metadata :name => "descMetadata",   :type => HydraPbcore::Datastream::Document
  has_metadata :name => "properties",     :type => Properties
  has_metadata :name => "assetReview",    :type => AssetReview

  # The only datastream with any binary data in it is a thumbnail datastream that stores a
  # small image of our video that we can use in the display.  Control group defaults to "M"
  # and we set versionable to false to keep our object size small.
  has_file_datastream :name => "thumbnail", :type=>ActiveFedora::Datastream, :label => "Thumbnail image", :versionable => false

  # We use the delegate_to method link term definitions and their datastreams to our
  # model's attributes.
  delegate_to :assetReview,
    [:reviewer, :date_updated, :complete, :priority, :license, :abstract]

  delegate_to :descMetadata,
    [:alternative_title, :chapter, :episode, :segment, :subtitle, :track,
     :translation, :lc_subject, :lc_name, :rh_subject, :subject, :summary, :contents,
     :getty_genre, :lc_genre, :lc_subject_genre, :genre, :event_place,
     :event_date, :contributor_name, :contributor_role, :publisher_name, :publisher_role,
     :note, :accession_number]

  # we use series to denote an archival series, but HydraPbcore::Datastream::Document defines series as an event series
  delegate :event_series, :to => :descMetadata, :at => [:series]

  # use HydraPcore::Datastream::Document.collection for additional collections that are not linked via RDF
  delegate :additional_collection, :to => :descMetadata, :at => [:collection]

  # Fields with only one value
  delegate :title, :to=> :descMetadata, :unique=>true
  validates_presence_of :title, :message => "Main title can't be blank"

  # label is used for the Fedora object, so we have to call our label something else
  delegate :title_label, :to=> :descMetadata, :at=>[:label]

  delegate_to :properties, [:depositor, :notes]
  delegate :converted, :to => :properties, :unique => true 
  # save the old fields from deprecated PBCore datastreams here
  delegate :collection_number, :to => :properties, :at => [:collection], :unique => true
  delegate :archival_series,   :to => :properties, :at => [:series],     :unique => true

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
    solr_doc.merge!("format_dtl_display" => self.access_format)
    solr_doc.merge!("heading_display"    => self.title)
    solr_doc.merge!("material_facet"     => "Digital")

    # Collect contributors and publishers and put them in the name_facet and contributors_display field
    name_facet = Array.new
    self.contributor_name.collect { |name| name_facet << name }
    self.publisher_name.collect { |name| name_facet << name }
    solr_doc.merge!("name_facet"           => name_facet) unless name_facet.empty?
    solr_doc.merge!("contributors_display" => name_facet) unless name_facet.empty?

    return solr_doc
  end

  # Override model method to merge in some additional fields as needed
  def to_solr solr_doc = Hash.new
    super(solr_doc)
    solr_doc.merge!({"format_ssi" => "Video"})
    # TODO: define a dynamic sort field
    #solr_doc.merge!({"title_sort" => self.title})

    unless self.collection.nil?
      facets = Array.new
      facets << self.collection.title
      facets << self.additional_collection
      solr_doc.merge!({"collection_ssim" => facets.flatten})
    end

    solr_doc.merge!({"archival_series_ssm" => self.series.title}) unless self.series.nil?
    solr_doc.merge!({"collection_number_ssm" => self.collection.pid.gsub(/:/,"-")}) unless self.collection.nil?
    
    return solr_doc
  end

end
