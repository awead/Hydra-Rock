module Rockhall::CollectionBehaviors

  # Returns array of solr ids for archival collections.
  # Ex: ["ARC-0001, "ARC-0034"]
  def get_collections_from_solr(solr_params = Hash.new)
    solr_params[:q]    = 'format:"Archival Collection"'
    solr_params[:fl]   = 'id'
    solr_params[:qt]   = 'document'
    solr_params[:rows] = 1000000

    solr = Rockhall::Discovery.solr_connect
    solr_response = solr.find(solr_params)
    return solr_response.docs.collect {|doc| doc[:id]}
  end

  # Returns array of solr ids of all the components of a given archival collection.
  # The ids returned are for series and subseries components, or components that
  # otherwise have child components attached to them.
  #   >  get_components_from_solr("ARC-0001")
  #   => ["ARC-0001:ref1", "ARC-0001:ref2"]
  def get_components_from_solr(solr_params = Hash.new)
    solr_params[:q]    = 'eadid_s:"' + self.discovery_id + '" AND component_children_b:TRUE'
    solr_params[:fl]   = 'id'
    solr_params[:qt]   = 'document'
    solr_params[:rows] = 1000000

    solr = Rockhall::Discovery.solr_connect
    solr_response = solr.find(solr_params)
    return solr_response.docs.collect {|doc| doc[:id]}.flatten
  end

  # Returns the parent component id of a given component.
  def get_parent_component_from_solr(solr_params = Hash.new)
    solr_params[:q]    = 'id:"' + self.discovery_id + '"'
    solr_params[:fl]   = 'parent_id_s'
    solr_params[:qt]   = 'document'
    solr_params[:rows] = 1

    solr = Rockhall::Discovery.solr_connect
    solr_response = solr.find(solr_params)
    result = solr_response.docs.collect {|doc| doc[:parent_id_s]}.flatten.first
  end

  # Creates a descMetadata datastream using the xml from the xml_display field in the solr
  # document.
  def get_xml_from_solr(solr_params = Hash.new)
    solr_params[:q]    = 'id:"' + self.discovery_id + '"'
    solr_params[:fl]   = 'xml_display'
    solr_params[:qt]   = 'document'
    solr_params[:rows] = 1

    solr = Rockhall::Discovery.solr_connect
    solr_response = solr.find(solr_params)
    xml = solr_response.docs.collect {|doc| doc[:xml_display]}.flatten.first
    if xml.nil?
      self.errors.add(:xml, ("ID " + self.discovery_id + " not found in discovery index"))
    else
      self.datastreams["descMetadata"].content = xml
    end
  end

  # By default, all collections are set to publicly readable
  def apply_default_permissions
    self.datastreams["rightsMetadata"].update_permissions( "group"=>{"public"=>"read"} )
    self.save
  end

end