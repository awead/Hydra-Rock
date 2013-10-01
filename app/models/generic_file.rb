class GenericFile < ActiveFedora::Base
  include Sufia::GenericFile
  include ActiveModel::Validations
  include Rockhall::Validations
  include Rockhall::TemplateMethods
  include Rockhall::Permissions
  include Rockhall::ModelMethods

  after_create :apply_default_permissions

  # Every possible term in the model, regardless of datastrem
  ALL_TERMS =
    [:title, :alternative_title, :chapter, :episode, :segment, :subtitle, :track,
     :translation, :lc_subject, :lc_name, :rh_subject, :subject, :summary, :contents,
     :getty_genre, :lc_genre, :lc_subject_genre, :genre, :event_series, :event_date, :event_place,
     :contributor_name, :contributor_role, :publisher_name, :publisher_role,
     :note, :accession_number, :additional_collection, 
     :relative_path, :depositor, :import_url, :date_uploaded, :date_modified]

  has_metadata :name => "descMetadata", :type => HydraPbcore::Datastream::GenericFile
  has_metadata :name => "properties",   :type => Properties

  delegate_to :properties, [:relative_path, :depositor, :import_url, :date_uploaded, :date_modified], :unique => true
  delegate_to :descMetadata,
    [:title, :alternative_title, :chapter, :episode, :segment, :subtitle, :track,
     :translation, :lc_subject, :lc_name, :rh_subject, :subject, :summary, :contents,
     :getty_genre, :lc_genre, :lc_subject_genre, :genre, :event_place,
     :event_date, :contributor_name, :contributor_role, :publisher_name, :publisher_role,
     :note, :accession_number]

  # we use series to denote an archival series, but HydraPbcore::Datastream::Document defines series as an event series
  delegate :event_series, :to => :descMetadata, :at => [:series]

  # use HydraPcore::Datastream::Document.collection for additional collections that are not linked via RDF
  delegate :additional_collection, :to => :descMetadata, :at => [:collection]

  # Sufia requires us to indicate all our fields as accessors.
  # This is used in conjuction with other methods such as #santize_attributes
  attr_accessible *(ALL_TERMS)

  # Needed for Sufia::Webform
  def terms_for_display
    ALL_TERMS
  end

  # Needed for Sufia::Webform
  # Remove terms that require inserted xml templates
  def terms_for_editing
    ALL_TERMS - [:contributor_name, :contributor_role, :publisher_name, :publisher_role, 
     :additional_collection, :accession_number,
     :event_date, :event_place, :event_series]
  end

  # Override Sufia::ModelMethods.apply_depositor_metadata
  def apply_depositor_metadata depositor
    depositor_id = depositor.respond_to?(:user_key) ? depositor.user_key : depositor
    self.depositor = depositor_id
    self.rightsMetadata.permissions({:person=>depositor_id}, 'edit') unless self.rightsMetadata.nil?
  end

  # Sufia expects these terms to be available in the model.  My GenericFile still inherits the terms delegated
  # to descMetadata in Sufia::GenericFile and I can't seem to figure out how to override that.
  def related_url
  end

  def based_near
  end

  def part_of
  end

  def resource_type
    alternative_title
  end

  def identifier
  end

  def language
  end

end