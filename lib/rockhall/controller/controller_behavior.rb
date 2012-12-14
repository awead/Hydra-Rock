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

  # Right now, anyone in the review group gets redirected to the reviewers edit page
  def enforce_review_controls
    user_groups = RoleMapper.roles(current_user.email)
    if user_groups.include?("reviewer")
      flash[:notice] = "You have been redirected to the review page for this document"
      redirect_to url_for(:controller=>"reviewers", :action=>"edit")
    end
  end

end