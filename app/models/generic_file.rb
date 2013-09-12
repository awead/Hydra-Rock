class GenericFile < ActiveFedora::Base
  include Sufia::GenericFile
  include ActiveModel::Validations
  include Rockhall::Validations
  include Rockhall::TemplateMethods
  include Rockhall::Permissions

  # Every possible term in the model, regardless of datastrem
  ALL_TERMS =
    [:title, :alternative_title, :chapter, :episode, :segment, :subtitle, :track,
     :translation, :title_label, :lc_subject, :lc_name, :rh_subject, :subject, :summary, :contents,
     :getty_genre, :lc_genre, :lc_subject_genre, :genre, :event_series, :event_date, :event_place,
     :contributor_name, :contributor_role, :publisher_name, :publisher_role,
     :note, :accession_number, :additional_collection, 
     :relative_path, :depositor, :import_url, :date_uploaded, :date_modified]

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

  # Getting this error in the web browser, but not in any of the spec tests:
  #   GenericFilesController::create rescued NoMethodError
  #    undefined method `empty?' for nil:NilClass
  #    /Users/adamw/Projects/Github/projecthydra/sufia/sufia-models/lib/sufia/models/generic_file.rb:148:in `label='
  #    /Users/adamw/Projects/Github/Hydra-Rock/.bundle/ruby/1.9.1/gems/hydra-core-6.3.4/lib/hydra/model_methods.rb:47:in `set_title_and_label'
  #    /Users/adamw/Projects/Github/Hydra-Rock/.bundle/ruby/1.9.1/gems/hydra-core-6.3.4/lib/hydra/model_methods.rb:32:in `add_file'
  #    /Users/adamw/Projects/Github/projecthydra/sufia/sufia-models/lib/sufia/models/generic_file/actions.rb:21:in `create_content'
  #    /Users/adamw/Projects/Github/projecthydra/sufia/lib/sufia/files_controller_behavior.rb:186:in `process_file'
  #    /Users/adamw/Projects/Github/projecthydra/sufia/lib/sufia/files_controller_behavior.rb:105:in `create_from_upload'
  #    /Users/adamw/Projects/Github/projecthydra/sufia/lib/sufia/files_controller_behavior.rb:72:in `create'
  #
  # The specific issue is that @inner_object at sufia/sufia-models/lib/sufia/models/generic_file.rb:147 is nil.
  # This does not happen in the spec tests and only occurs when I'm using the application to upload files.
  #
  # For now the solution is to override the method to return nil.  This at least allows files to be uploaded.
  def label=(new_label)
    nil
  end

  # Sufia expects these terms to be available in the model.  My GenericFile still inherits the terms delegated
  # to descMetadata in Sufia::GenericFile and I can't seem to figure out how to override that.
  def related_url
  end

  def based_near
  end

  def part_of
  end

  def tag
  end

  def description
  end

  def rights
  end

  def date_created
  end

  def resource_type
    alternative_title
  end

  def identifier
  end

  def language
  end

end