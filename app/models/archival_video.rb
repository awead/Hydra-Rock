require "hydra"

class ArchivalVideo < ActiveFedora::Base

  include Hydra::ModelMethods
  include Rockhall::ModelMethods
  include Rockhall::WorkflowMethods

  has_relationship "objects", :is_part_of, :inbound => true

  # Uses the Hydra Rights Metadata Schema for tracking access permissions & copyright
  has_metadata :name => "rightsMetadata", :type => Hydra::RightsMetadata

  has_metadata :name => "descMetadata", :type => Rockhall::PbcoreDocument do |m|
  end

  has_metadata :name => "properties", :type => ActiveFedora::MetadataDatastream do |m|
    m.field 'collection', :string
    m.field 'depositor', :string
    m.field 'notes', :text
    m.field 'access', :string
    m.field 'submission', :string
  end

  has_metadata :name => "assetReview", :type => ActiveFedora::MetadataDatastream do |m|
    m.field 'reviewer', :string
    m.field 'date_completed', :string
    m.field 'date_updated', :string
    m.field 'license', :string
    m.field 'notes', :text
  end

  def initialize( attrs={} )
    super
    # Apply group permissions
    self.datastreams_in_memory["rightsMetadata"].update_permissions( "group"=>{"archivist"=>"edit"} )
    self.datastreams_in_memory["rightsMetadata"].update_permissions( "group"=>{"reviewer"=>"edit"} )
    self.datastreams_in_memory["rightsMetadata"].update_permissions( "group"=>{"donor"=>"read"} )
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
        results[obj.label.to_sym] = obj.pid if obj.datastreams_in_memory.keys.include?("PRESERVATION1")
        results[obj.label.to_sym] = obj.pid if obj.datastreams_in_memory.keys.include?("ACCESS1")
      end
    end
    results[:unknown] = u_files
    return results
  end

  def apply_reviewer_metadata(reviewer,license,opts={})
    date = DateTime.now
    if self.datastreams_in_memory["assetReview"].get_values(:date_completed).first.nil?
      self.datastreams_in_memory["assetReview"].update_indexed_attributes({[:date_completed] => { 0 => date.strftime("%Y-%m-%d")}})
    end
    unless opts[:notes].nil?
      self.datastreams_in_memory["assetReview"].update_indexed_attributes({[:notes] => { 0 => opts[:notes]}})
    end
    self.datastreams_in_memory["assetReview"].update_indexed_attributes({[:date_updated] => { 0 => date.strftime("%Y-%m-%d")}})
    self.datastreams_in_memory["assetReview"].update_indexed_attributes({[:reviewer] => { 0 => reviewer}})
    self.datastreams_in_memory["assetReview"].update_indexed_attributes({[:license] => { 0 => license}})
  end


end
