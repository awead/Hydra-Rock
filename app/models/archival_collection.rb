class ArchivalCollection < ActiveFedora::Base

  include Rockhall::CollectionBehaviors

  after_create :apply_defaults

  has_metadata :name => "descMetadata",   :type => DublinCore
  has_metadata :name => "rightsMetadata", :type => Hydra::Datastream::RightsMetadata

  has_many :series, :property => :is_member_of_collection, :class_name => "ArchivalComponent"
  has_many :videos, :property => :is_member_of_collection, :class_name => "ArchivalVideo"

  delegate :title, :to=> :descMetadata, :multiple => false
  delegate :format, :to=> :descMetadata, :multiple => false

  # The id for the solr document of an archival collection as is is in our discovery
  # index is different than the solr document for the collection here in Fedora.
  # Ex:
  # The fedora id for an archival collection here is "arc:foo" but in the discovery index,
  # it'll be "ARC-FOO".
  def discovery_id
    return self.pid.upcase.gsub(/:/,"-")
  end

  def apply_defaults
    self.format = "Collection"
    self.apply_default_permissions
  end

  # TODO: this should go someplace else?
  def get_thumbnail_url
    #return image_tag("archival_collections.png")
  end

  def update_components
    self.delete_components
    components = self.get_components_from_solr
    components.each do |id|
      pid = "arc:" + id.gsub(/^ARC-/,"").gsub(/:/,"-").downcase
      c = ArchivalComponent.new(:pid=>pid)
      c.get_title_from_solr
      c.save
      self.series << c
    end
    components.each do |id|
      pid = "arc:" + id.gsub(/^ARC-/,"").gsub(/:/,"-").downcase
      c = ArchivalComponent.find(pid)
      parent_ref = c.get_parent_component_from_solr
      unless parent_ref.nil?
        parent = ArchivalComponent.find((self.pid + parent_ref))
        parent.sub_series << c
        parent.save
        c.save
      end
    end
  end

  def delete_components
    self.series.each {|c| c.delete}
  end

end