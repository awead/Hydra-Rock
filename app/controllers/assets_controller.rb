class AssetsController < ApplicationController
  include Hydra::Assets

  prepend_before_filter :enforce_asset_creation_restrictions, :only=>:new

  def enforce_asset_creation_restrictions
    user_groups = RoleMapper.roles(current_user.login)
    unless user_groups.include?("archivist") or user_groups.include?("reviewer")
      flash[:notice] = "You are not allowed to create new content"
      redirect_to url_for(root_path)
    end
  end

end
