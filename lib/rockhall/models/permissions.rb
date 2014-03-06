module Rockhall::Models::Permissions
  extend ActiveSupport::Concern

  include Hydra::AccessControls::Permissions

  def update_permissions permissions
    self.permissions_attributes = permissions
    self.save
  end

  def apply_default_permissions
    self.read_groups = ["donor"]
    self.edit_groups = ["archivist"]
    self.save
  end

  def is_discoverable?
    self.discover_groups.include?("public") || self.read_groups.include?("public")
  end

end
