module Rockhall::Permissions

  include Hydra::ModelMixins::RightsMetadata

  def update_permissions permissions
    self.permissions = permissions
    self.save
  end

  def apply_default_permissions
    self.read_groups = ["donor"]
    self.edit_groups = ["archivist"]
    self.save
  end

end