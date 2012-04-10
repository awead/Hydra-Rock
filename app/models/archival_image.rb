require "hydra"

class ArchivalImage < ActiveFedora::Base

  include ActiveFedora::Relationships
  include Hydra::GenericImage
  include Hydra::ModelMethods
  include Rockhall::ModelMethods

  has_relationship "objects", :is_part_of, :inbound => true

  # Uses the Hydra Rights Metadata Schema for tracking access permissions & copyright
  has_metadata :name => "rightsMetadata", :type => Hydra::RightsMetadata

  # Custom mods datastream
  has_metadata :name => "descMetadata", :type => Rockhall::ModsImage do |m|
  end

  has_metadata :name => "properties", :type => Rockhall::Properties do |m|
  end
  delegate :depositor, :to=>'properties', :at=>[:depositor]

  def initialize( attrs={} )
    super
  end

  def apply_depositor_metadata(depositor_id)
    self.depositor = depositor_id
    super
  end

end
