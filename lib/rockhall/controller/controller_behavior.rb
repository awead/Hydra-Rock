module Rockhall::Controller::ControllerBehavior

  include Rockhall::Controller::PermissionsEnforcement

  def update_session
    session[:search][:counter] = params[:counter] unless params[:counter].nil?
  end

  # Gets the active_fedora object in the show views of CatalogController.
  #
  # The show view only has a SolrDocument, but we need the actual fedora 
  # object in order to  display more information about it, such as child
  # objects that are attached to it.
  def get_af_doc
    @afdoc = ActiveFedora::Base.find(params[:id], :cast => true)
  end

  def get_public_acticity
    @activities = PublicActivity::Activity.order(:created_at).reverse_order.limit(20)
  end

  def record_activity parameters
    unless current_user.nil?
      current_user.create_activity :activity, params: parameters, owner: current_user
    end
  end

  def update_relation relation, message = String.new
    if params["archival_video"][relation].empty? && !@afdoc.collection.nil?
      message = "Removed video from #{@afdoc.send(relation).title}"
      @afdoc.send(relation+"=", nil)
    end

    if @afdoc.send(relation).nil?
      unless params["archival_video"][relation].empty?
        @afdoc.send(relation+"=", ActiveFedora::Base.find(params["archival_video"][relation], :cast => true))
        message = "Assigned video to #{@afdoc.send(relation).title}"
      end
    else
      unless params["archival_video"][relation].match(@afdoc.send(relation).pid)
        @afdoc.send(relation+"=", ActiveFedora::Base.find(params["archival_video"][relation], :cast => true))
        message = "Moved video to #{@afdoc.send(relation).title}"
      end
    end
    return message
  end

  # Takes the :permissions portion of the parameters hash, and reformats it so it can be passed to the model
  # for updating.
  def format_permissions_hash params, permissions = Array.new
    params["users"].each { |k,v| permissions << {:type => "user", :name => k, :access => v} }   unless params["users"].nil?
    params["groups"].each { |k,v| permissions << {:type => "group", :name => k, :access => v} } unless params["groups"].nil?
    return permissions
  end

 # Forms use empty strings to delete terms, but AF won't delete the terms unless they're nil, so we replace
 # empty strings and arrays with nil.
  def format_parameters_hash params, hash = Hash.new
    params.each_pair do |k,v|
      if v.empty? || v == [""]
        hash[k] = nil
      else
        hash[k] = v.is_a?(Array) ? v.delete_if { |e| e.blank? } : v
      end
    end
    return hash
  end

  # overrides Blacklight::SolrHelper
  # Explicity defaults the rows parameter to 10.  This avoids the exception raised at Blacklight::SolrHelper#167 because
  # non-Blacklight controllers can't seem to determine the rows parameter when it is absent, even though it's set in the
  # CatalogController.
  def add_paging_to_solr(solr_params, user_params)
    user_params[:rows] ||= 10
    super
  end

   

end