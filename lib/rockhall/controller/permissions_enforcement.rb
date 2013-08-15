module Rockhall::Controller::PermissionsEnforcement

  def enforce_create_permissions
    unless can? :create, current_user
      flash[:alert] = "You are not allowed to create new content"
      redirect_to root_path
    end
  end

  # uses enforce_edit_permissions for now
  def enforce_delete_permissions
    enforce_edit_permissions
  end

  def enforce_edit_permissions
    unless can? :edit, params[:id]
      redirect_to catalog_path(params[:id])
      flash[:alert] = "You are not allowed to edit this item"
    end
  end


end