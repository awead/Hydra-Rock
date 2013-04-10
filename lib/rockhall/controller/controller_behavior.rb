module Rockhall::Controller::ControllerBehavior

  def update_session
    logger.info "Updating session with parameters:" + params.inspect
    session[:search][:counter] = params[:counter] unless params[:counter].nil?
    logger.info "Session now: " + session.inspect
  end

  def changed_fields(params)
    changes = Hash.new
    return changes if params[:document_fields].nil?
    object = get_model_from_pid(params[:id])
    logger.info("\n\n\n\n\n" + params[:document_fields].inspect + "\n\n\n\n\n\n")
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

  def get_model_from_pid(id)
    af = ActiveFedora::Base.load_instance_from_solr(id)
    af.relationships.data.each_statement do |s|
      if s.object.to_s.match("afmodel")
        model = s.object.to_s.gsub("info:fedora/afmodel:","")
        return eval(model).find(id)
      end
    end
  end

  def enforce_asset_creation_restrictions
    user_groups = RoleMapper.roles(current_user.email)
    unless user_groups.include?("archivist") or user_groups.include?("reviewer")
      flash[:notice] = "You are not allowed to create new content"
      redirect_to url_for(root_path)
    end
  end

  # Ensure that reviewers can only edit items via the reviewers controller.
  #
  # Add this method to any controller for models where you don't want revierwers
  # to be able to edit via the default interface.
  def enforce_review_controls
    user_groups = RoleMapper.roles(current_user.email)
    if user_groups.include?("reviewer")
      flash[:notice] = "You have been redirected to the review page for this document"
      redirect_to url_for(:controller=>"reviewers", :action=>"edit")
    end
  end

  # Gets the active_fedora object in the show views of CatalogController.
  #
  # The show view only has a SolrDocument, but we need the actual fedora 
  # object in order to  display more information about it, such as child
  # objects that are attached to it.
  def get_af_doc
    @afdoc = get_model_from_pid(params[:id])
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
   

end