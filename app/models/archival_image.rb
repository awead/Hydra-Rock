require "hydra"

class ArchivalImage < ActiveFedora::Base

  include Hydra::GenericImage
  include Hydra::ModelMethods
  include Rockhall::ModelMethods

  # These will need to be included to avoid deprecation warnings is later versions of HH
  #include ActiveFedora::Relationships

  has_relationship "objects", :is_part_of, :inbound => true

  # Uses the Hydra Rights Metadata Schema for tracking access permissions & copyright
  has_metadata :name => "rightsMetadata", :type => Hydra::RightsMetadata

  # Custom mods datastream
  has_metadata :name => "descMetadata", :type => Rockhall::ModsImage do |m|
  end

  # A place to put extra metadata values
  has_metadata :name => "properties", :type => ActiveFedora::MetadataDatastream do |m|
    m.field 'collection', :string
    m.field 'depositor', :string
    m.field 'notes', :text
    m.field 'access', :string
  end

  def initialize( attrs={} )
    super
  end

end
