module PermissionsHelper

  def permisison_choices
    { "No Access"=>"none", "Edit" => "edit", "Read/Download" => "read", "Discover" => "discover" }
  end

  def role_names
    RoleMapper.role_names << "public"
  end

  def get_access_for_role role=nil
    return "none" if role.nil?
    @afdoc.rightsMetadata.groups[role]
  end

  def current_user_permissions
    @afdoc.rightsMetadata.individuals[current_user.email]
  end

end