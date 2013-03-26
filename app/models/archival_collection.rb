class ArchivalCollection < ActiveFedora::Base

  include ActiveFedora::DatastreamCollections
  include ActiveFedora::Relationships
  include Rockhall::CollectionBehaviors

  after_create :apply_default_permissions

  has_metadata :name => "descMetadata",   :type => EadDocument
  has_metadata :name => "rightsMetadata", :type => Hydra::Datastream::RightsMetadata

  has_many :series, :property => :is_member_of_collection, :class_name => "ArchivalComponent"
  has_many :videos, :property => :is_member_of_collection, :class_name => "ArchivalVideo"

  delegate :title, :to=> :descMetadata, :at=>[:collection], :unique=>true

  # The id for the solr document of an archival collection as is is in our discovery
  # index is different than the solr document for the collection here in Fedora.
  # Ex:
  # The fedora id for an archival collection here is "arc:foo" but in the discovery index,
  # it'll be "ARC-FOO".
  def discovery_id
    return self.pid.upcase.gsub(/:/,"-")
  end

  def update_components
    self.delete_components
    components = self.get_components_from_solr
    components.each do |id|
      pid = "arc:" + id.gsub(/^ARC-/,"").gsub(/:/,"-").downcase
      c = ArchivalComponent.new(:pid=>pid)
      c.get_xml_from_solr
      c.archival_group_append self
      c.save
    end
    components.each do |id|
      pid = "arc:" + id.gsub(/^ARC-/,"").gsub(/:/,"-").downcase
      c = ArchivalComponent.find(pid)
      parent_ref = c.get_parent_component_from_solr
      unless parent_ref.nil?
        parent = ArchivalComponent.find((self.pid + "-" + parent_ref))
        c.archival_group_append parent
        c.save
      end
    end
  end

  def delete_components
    self.component.each {|c| c.delete}
  end

end