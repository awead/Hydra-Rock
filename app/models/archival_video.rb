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

  def initialize( attrs={} )
    super
  end

  def ingest(sip)
    raise "SIP is not ready" unless sip.status == "ready"
    i = 0
    objects = get_file_objects

    # Add preservation file
    unless objects.include?(sip.preservation)
      single_ingest( sip.preservation, Blacklight.config[:video][:preservation_host], { :label => "preservation", :directory => Blacklight.config[:video][:preservation_location] })
      i = i + 1
    end

    # Add high-quality access file
    unless objects.include?(sip.access_hq)
      single_ingest( sip.access_hq, Blacklight.config[:video][:access_host], { :label => "access_hq", :directory => Blacklight.config[:video][:access_location] })
      i = i + 1
    end

    # Add low-quality access file
    unless objects.include?(sip.access_lq)
     single_ingest( sip.access_lq, Blacklight.config[:video][:access_host], { :label => "access_lq", :directory => Blacklight.config[:video][:access_location] })
      i = i + 1
    end

    return "Ingested #{i} file(s)"

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

  def single_ingest(file, location, opts={})
    dslocation = location + file
    begin
      ev = ExternalVideo.new
      opts[:label].nil? ? ev.label = file : ev.label = opts[:label]
      ev.add_named_datastream("externalContent", :label=>file, :dsLocation=>dslocation, :directory=>opts[:directory])
      ev.apply_depositor_metadata(Blacklight.config[:video][:depositor])
      ev.datastreams_in_memory["rightsMetadata"].update_permissions( "group"=>{"public"=>"read"} )
      self.file_objects_append(ev)
      self.save
    rescue Exception=>e
      return "Failed to add datastream: #{e}"
    end
    return nil
  end

  def external_video(type)
    self.file_objects.each do |obj|
      if type.to_s == obj.label
        return obj
      end
    end
    return nil
  end

  private

  def get_file_objects
    results = Array.new
    self.file_objects.each do |obj|
      results << obj.datastreams_in_memory["EXTERNALCONTENT1"].label
    end
    return results
  end

end
