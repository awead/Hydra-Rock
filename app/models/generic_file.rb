class GenericFile < ActiveFedora::Base
  include Sufia::GenericFile
  include ActiveModel::Validations
  include Rockhall::Validations
  include Rockhall::TemplateMethods
  include Rockhall::Permissions

  has_metadata :name => "descMetadata", :type => HydraPbcore::Datastream::Document
  has_metadata :name => "properties",   :type => Properties

  delegate_to :properties, [:relative_path, :depositor, :import_url, :date_uploaded, :date_modified], :unique => true
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

  # label is used for the Fedora object, so we have to call our label something else
  delegate :title_label, :to=> :descMetadata, :at=>[:label]

  # Sufia requires us to indicate all our fields as accessors.
  # This is used in conjuction with other methods such as #santize_attributes
  attr_accessible :title, :alternative_title, :chapter, :episode, :segment, :subtitle, :track,
    :translation, :lc_subject, :lc_name, :rh_subject, :subject, :summary, :contents,
    :getty_genre, :lc_genre, :lc_subject_genre, :genre, :event_place,
    :event_date, :contributor_name, :contributor_role, :publisher_name, :publisher_role,
    :note, :accession_number

  # Needed for Sufia
  def terms_for_display
    [:title, :alternative_title, :chapter, :episode, :segment, :subtitle, :track,
     :translation, :lc_subject, :lc_name, :rh_subject, :subject, :summary, :contents,
     :getty_genre, :lc_genre, :lc_subject_genre, :genre, :event_place,
     :event_date, :contributor_name, :contributor_role, :publisher_name, :publisher_role,
     :note, :accession_number, :relative_path, :depositor, :import_url, :date_uploaded, :date_modified,
     :event_series, :additional_collection, :title_label]
  end

  # Needed for Sufia
  def terms_for_editing
    terms_for_display
  end

  # Weird things happen when Sufia calls this method for us. It may be because Sufia uses RDF datastreams
  # and we're not.  For now, this method is overrided to simply return nil.
  def initialize_fields
    nil
  end

end