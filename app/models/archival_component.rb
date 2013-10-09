class ArchivalComponent < ActiveFedora::Base

  include Rockhall::CollectionBehaviors

  # An archival component belongs to one collection
  belongs_to :collection, :property => :is_member_of_collection, :class_name => "ArchivalCollection"

  # can and also belong to other components
  has_many   :sub_series, :property => :is_subset_of, :class_name => "ArchivalComponent"
  belongs_to :series,     :property => :is_subset_of, :class_name => "ArchivalComponent"

  # and have many items in them
  has_many :videos, :property => :is_member_of, :class_name => "ArchivalVideo"

  has_metadata :name => "descMetadata", :type => DublinCore
  delegate :title, :to=> :descMetadata, :multiple => false

  # The solr ids for components appear as:
  #    ARC-0003:ref1
  # However, their fedora pids look like:
  #    arc:0003-ref1
  # This method takes the fedora pid and translates it to the solr id.
  def discovery_id
    self.pid.gsub(/-/,":").gsub(/^arc:/,"ARC-")
  end

end