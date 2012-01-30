require "hydra"

class ArchivalVideo < ActiveFedora::Base

  include Hydra::ModelMethods
  include Rockhall::ModelMethods
  include Rockhall::WorkflowMethods

  # These will need to be included to avoid deprecation warnings is later versions of HH
  #include ActiveFedora::FileManagement
  #include ActiveFedora::Relationships
  #include ActiveFedora::DatastreamCollections

  has_relationship "objects", :is_part_of, :inbound => true

  # Uses the Hydra Rights Metadata Schema for tracking access permissions & copyright
  has_metadata :name => "rightsMetadata", :type => Hydra::RightsMetadata

  has_metadata :name => "descMetadata", :type => Rockhall::PbcoreDocument do |m|
  end

  has_metadata :name => "properties", :type => ActiveFedora::MetadataDatastream do |m|
    m.field 'collection', :string # TODO: delete this field from all objects
    m.field 'depositor', :string
    m.field 'notes', :text
    m.field 'access', :string
    m.field 'submission', :string
  end

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

  def remove_file_objects
    if self.file_objects.count > 0
      self.file_objects.each do |obj|
        ActiveFedora::Base.load_instance(obj.pid).delete
      end
      return true
    else
      return false
    end
  end

  def external_video(type)
      self.file_objects.each do |obj|
        if type.to_s == obj.label
          return obj
        end
      end
      return nil
  end

  def videos
    results = Hash.new
    u_files = Array.new
    self.file_objects.each do |obj|
      if obj.label.nil?
        u_files << obj.pid
      else
        results[obj.label.to_sym] = obj.pid if obj.datastreams.keys.include?("PRESERVATION1")
        results[obj.label.to_sym] = obj.pid if obj.datastreams.keys.include?("ACCESS1")
      end
    end
    results[:unknown] = u_files
    return results
  end

end
