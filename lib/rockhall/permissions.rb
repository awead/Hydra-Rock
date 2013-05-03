module Rockhall::Permissions

  def permissions
    {
      "groups"      => self.rightsMetadata.groups,
      "individuals" => self.rightsMetadata.individuals
    }
  end

  def permissions_changed? params
    params == self.permissions ? FALSE : TRUE
  end

  def update_permissions params
    if permissions_changed?(params)  
      update_hash = {
        "group"  => params["groups"],
        "person" => params["individuals"]
      }      
      self.rightsMetadata.update_permissions update_hash
    end
  end

end