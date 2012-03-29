require "hydra"

class DigitalVideo < ActiveFedora::Base

  include Hydra::ModelMethods
  include Rockhall::ModelMethods
  include Rockhall::WorkflowMethods
  include Hydra::SubmissionWorkflow

  # These will need to be included to avoid deprecation warnings is later versions of HH
  include ActiveFedora::FileManagement
  include ActiveFedora::Relationships
  include ActiveFedora::DatastreamCollections

  has_relationship "objects", :is_part_of, :inbound => true

  # Uses the Hydra Rights Metadata Schema for tracking access permissions & copyright
  has_metadata :name => "rightsMetadata", :type => Hydra::RightsMetadata

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

  def apply_depositor_metadata(depositor_id)
    self.depositor = depositor_id
    super
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
    objects = Array.new
    self.file_objects.each do |obj|
      if type.to_s == obj.label
        objects << obj
      end
    end
    return objects
  end

  def videos
    results = Hash.new
    u_files = Array.new
    p_files = Array.new
    self.file_objects.each do |obj|
      if obj.label.nil?
        u_files << obj.pid
      else
        if obj.datastreams.keys.include?("PRESERVATION1")
          p_files << obj.pid
        end
        results[obj.label.to_sym] = obj.pid if obj.datastreams.keys.include?("ACCESS1")
      end
    end
    results[:unknown] = u_files
    results[:original] = p_files
    return results
  end

  def access_file
    unless self.external_video(:h264).nil?
      return self.external_video(:h264).datastreams["descMetadata"].get_values(:name)
    end
  end

  def access_format
    unless self.external_video(:h264).nil?
      return self.external_video(:h264).datastreams["descMetadata"].get_values(:video_encoding)
    end
  end

  def addl_solr_fields
    solr_doc = Hash.new
    solr_doc.merge!(:access_file_s => self.access_file)
    solr_doc.merge!(:format_dtl_display => self.access_format)
  end

end
