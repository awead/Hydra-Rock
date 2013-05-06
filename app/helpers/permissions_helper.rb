module PermissionsHelper

  def permisison_choices
    { "No Access"=>"none", "Discover" => "discover", "Read/Download" => "read", "Edit" => "edit"}
  end

  def get_access_for_role role=nil
    return "none" if role.nil?
    @afdoc.rightsMetadata.groups[role]
  end

  def current_user_permissions
    @afdoc.rightsMetadata.individuals[current_user.email]
  end


end