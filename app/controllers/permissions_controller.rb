class PermissionsController < ApplicationController

  include Hydra::AccessControlsEnforcement
  
  before_filter :enforce_access_controls
  
  def show
    @document_fedora=ActiveFedora::Base.find(params[:id], :cast=>true)
    
    respond_to do |format|
      format.html 
      format.inline { render :partial=>"hydra/permissions/index", :format=>"html" }
    end
  end
  
  def new
    respond_to do |format|
      format.html 
      format.inline { render :partial=>"hydra/permissions/new" }
    end
  end
  
  def edit
    @document_fedora=ActiveFedora::Base.find(params[:id], :cast=>true)
    
    respond_to do |format|
      format.html 
      format.inline {render :action=>"edit", :layout=>false}
    end
  end
  
  # Create a new permissions entry
  # expects permission["actor_id"], permission["actor_type"] and permission["access_level"] as params. ie.   :permission=>{"actor_id"=>"_person_id_","actor_type"=>"person","access_level"=>"read"}
  def create
    @document_fedora=ActiveFedora::Base.find(params[:id], :cast=>true)

    access_actor_type = params["permission"]["actor_type"]
    actor_id = params["permission"]["actor_id"]
    access_level = params["permission"]["access_level"]
  
    # update the datastream's values
    result = @document_fedora.rightsMetadata.permissions({access_actor_type => actor_id}, access_level)
    @document_fedora.save
    
    flash[:notice] = "#{actor_id} has been granted #{access_level} permissions for #{params[:id]}"
    
    respond_to do |format|
      format.html do 
        if params.has_key?(:add_permission)
          redirect_to :back
        else
          redirect_to next_step(params[:id])
        end
        
      end
      format.inline { render :partial=>"hydra/permissions/edit_person_permissions", :locals=>{:person_id=>actor_id}}
    end

  end
  
  # Updates the permissions for all actors in a hash.  Can specify as many groups and persons as you want
  # ie. :permission => {"group"=>{"group1"=>"discover","group2"=>"edit"}, {"person"=>{"person1"=>"read"}}}
  def update    
    @document_fedora=ActiveFedora::Base.find(params[:id], :cast=>true)
    
    # update the datastream's values
    result = @document_fedora.rightsMetadata.update_permissions(params[:permission])
    
    @document_fedora.save
    
    
    flash[:notice] = "The permissions have been updated."
    
    respond_to do |format|
      format.html do
        if params.has_key?(:add_permission)
          redirect_to edit_permission_path(params[:id], :add_permission => true)
        else
          redirect_to next_step(params[:id])
        end
      end
      format.inline do
        # This should be replaced ...
        if params[:permission].has_key?(:group)
          access_actor_type = "group"
        else
          access_actor_type = "person"
        end
        actor_id = params["permission"][access_actor_type].first[0]
        render :partial=>"hydra/permissions/edit_person_permissions", :locals=>{:person_id=>actor_id} 
      end
    end
    
  end
    
end
