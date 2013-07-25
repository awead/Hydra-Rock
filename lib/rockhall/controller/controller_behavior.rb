module Rockhall::Controller::ControllerBehavior

  include Rockhall::Controller::AccessBehavior

  def update_session
    session[:search][:counter] = params[:counter] unless params[:counter].nil?
  end

  # Deprecated
  def changed_fields(params)
    changes = Hash.new
    return changes if params[:document_fields].nil?
    object = ActiveFedora::Base.find(params[:id], :cast => true)
    params[:document_fields].each do |k,v|
      if params[:document_fields][k.to_sym].kind_of?(Array)
        unless object.send(k.to_sym) == v or (object.send(k.to_sym).empty? and v.first.empty?) or (v.sort.uniq.count > object.send(k.to_sym).count and v.sort.uniq.first.empty?)
          changes.store(k,v)
        end
      else
        unless object.send(k.to_sym) == v
          changes.store(k,v)
        end
      end
    end
    return changes
  end

  def enforce_asset_creation_restrictions
    user_groups = RoleMapper.roles(current_user.email)
    unless user_groups.include?("archivist")
      flash[:notice] = "You are not allowed to create new content"
      redirect_to url_for(root_path)
    end
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

  # overrides Blacklight::SolrHelper
  # Explicity defaults the rows parameter to 10.  This avoids the exception raised at Blacklight::SolrHelper#167 because
  # non-Blacklight controllers can't seem to determine the rows parameter when it is absent, even though it's set in the
  # CatalogController.
  def add_paging_to_solr(solr_params, user_params)
    user_params[:rows] ||= 10
    super
  end

   

end