module Rockhall::CollectionBehaviors

  # Returns array of solr ids of all the components of a given archival collection.
  # The ids returned are for series and subseries components, or components that
  # otherwise have child components attached to them.
  #   >  get_components_from_solr("ARC-0001")
  #   => ["ARC-0001:ref1", "ARC-0001:ref2"]
  def get_components_from_solr d = Rockhall::Discovery.new, solr_params = Hash.new
    solr_params[:q]    = 'ead_id:"' + self.discovery_id + '" AND component_children_b:TRUE'
    solr_params[:fl]   = 'id'
    solr_params[:qt]   = 'document'
    solr_params[:rows] = 1000000
    solr_response = d.solr.get 'select', :params => solr_params
    return solr_response["response"]["docs"].collect {|doc| doc["id"]}.flatten
  end

  # Returns the parent component id of a given component.
  def get_parent_component_from_solr d = Rockhall::Discovery.new
    solr_response = d.solr.get 'select', :params => { :q=>"id:#{self.discovery_id}", :qt=>"document" }
    doc = solr_response["response"]["docs"].first
    return doc["parent_id"] unless doc.nil?
  end

  # Queries the solr_discovery index (i.e. Blacklight) and sets the object's title
  # to the title_display field in solr.
  def get_title_from_solr d = Rockhall::Discovery.new
    solr_response = d.solr.get 'select', :params => { :q=>"id:#{self.discovery_id}", :qt=>"document" }
    doc = solr_response["response"]["docs"].first
    doc.nil? ? self.errors.add(:get_title_from_solr, ("ID " + self.discovery_id + " not found in discovery index")) : self.title = doc["title_display"]
  end

  # By default, all collections are set to publicly readable
  def apply_default_permissions
    self.datastreams["rightsMetadata"].update_permissions( "group"=>{"public"=>"read"} )
    self.save
  end

end