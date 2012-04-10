require "hydra"

class DigitalVideo < ActiveFedora::Base

  include Hydra::ModelMethods
  include Rockhall::ModelMethods
  include Rockhall::WorkflowMethods
  include Hydra::SubmissionWorkflow
  include ActiveFedora::FileManagement
  include ActiveFedora::Relationships
  include ActiveFedora::DatastreamCollections

  has_relationship "objects", :is_part_of, :inbound => true

  has_metadata :name => "rightsMetadata", :type => Hydra::Datastream::RightsMetadata

  has_metadata :name => "descMetadata", :type => Rockhall::PbcoreDigitalDocument do |m|
  end

  has_metadata :name => "properties", :type => Rockhall::Properties do |m|
  end
  delegate :depositor, :to=>'properties', :at=>[:depositor]

  has_metadata :name => "assetReview", :type => Rockhall::AssetReview do |m|
  end
  delegate :reviewer,       :to=>'assetReview', :at=>[:reviewer]
  delegate :date_updated,   :to=>'assetReview', :at=>[:date_updated]
  delegate :complete,       :to=>'assetReview', :at=>[:complete]
  delegate :priority,       :to=>'assetReview', :at=>[:priority]

  def initialize( attrs={} )
    super
    # Apply group permissions
    self.datastreams["rightsMetadata"].update_permissions( "group"=>{"archivist"=>"edit"} )
    self.datastreams["rightsMetadata"].update_permissions( "group"=>{"reviewer"=>"edit"} )
    self.datastreams["rightsMetadata"].update_permissions( "group"=>{"donor"=>"read"} )
  end

end
