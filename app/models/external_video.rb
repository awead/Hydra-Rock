class ExternalVideo < ActiveFedora::Base

  include ActiveFedora::DatastreamCollections
  include ActiveFedora::FileManagement
  include ActiveFedora::Relationships
  include Hydra::ModelMethods
  include Rockhall::ModelMethods

  has_relationship "is_member_of_collection", :has_collection_member, :inbound => true
  has_bidirectional_relationship "part_of", :is_part_of, :has_part

  delegate :name,       :to=> :descMetadata
  delegate :generation, :to=> :descMetadata
  delegate :format,     :to=> :descMetadata
  delegate :vendor,     :to=> :descMetadata
  delegate :next,       :to=> :descMetadata
  delegate :previous,   :to=> :descMetadata
  delegate :name,       :to=> :descMetadata
  delegate :size,       :to=> :descMetadata
  delegate :size_units, :to=> :descMetadata
  delegate :date,       :to=> :descMetadata
  delegate :media_type, :to=> :descMetadata
  delegate :colors,     :to=> :descMetadata
  delegate :depositor,  :to=> :properties

  # Object will have either an access or a perservation datastream but not both
  has_datastream :name=>"access",       :type=>ActiveFedora::Datastream, :controlGroup=>'E'
  has_datastream :name=>"preservation", :type=>ActiveFedora::Datastream, :controlGroup=>'E'

  has_metadata :name => "rightsMetadata", :type => Hydra::Datastream::RightsMetadata
  has_metadata :name => "descMetadata",   :type => Rockhall::PbcoreInstantiation
  has_metadata :name => "mediaInfo",      :type => MediainfoXml::Document
  has_metadata :name => "properties",     :type => Rockhall::Properties

  def initialize( attrs={} )
    super
    # Anyone in the archivist group has edit rights
    self.datastreams["rightsMetadata"].update_permissions( "group"=>{"archivist"=>"edit"} )
    self.datastreams["rightsMetadata"].update_permissions( "group"=>{"donor"=>"read"} )
  end

  # deletes the object identified by pid if it does not have any objects asserting has_collection_member
  def self.garbage_collect(pid)
    begin
      obj = self.find(pid)
      if obj.containers.empty?
        obj.delete
      end
    rescue
    end
  end

end
