module Rockhall::Controller::ControllerBehaviour

  def update_session
    logger.info "Updating session with parameters:" + params.inspect
    session[:search][:counter] = params[:counter] unless params[:counter].nil?
    logger.info "Session now: " + session.inspect
  end

  def changed_fields(params)
    changes = Hash.new
    return changes if params[:document_fields].nil?
    object = get_model_from_pid(params[:id])
    params[:document_fields].each do |k,v|
      unless object.send(k.to_sym) == v or (object.send(k.to_sym).empty? and v.first.empty?) or (v.sort.uniq.count > object.send(k.to_sym).count and v.sort.uniq.first.empty?)
        changes.store(k,v)
      end
    end
    return changes
  end


  def get_model_from_pid(id)
    af = ActiveFedora::Base.find(id)
    af.relationships.data.each_statement do |s|
      if s.object.to_s.match("afmodel")
        model = s.object.to_s.gsub("info:fedora/afmodel:","")
        return eval(model).find(id)
      end
    end
  end


end