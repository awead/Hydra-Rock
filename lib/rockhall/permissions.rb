module Rockhall::Permissions

  include Hydra::ModelMixins::RightsMetadata

  def permissions_changed? permissions
    permissions == self.permissions ? FALSE : TRUE
  end

  def update_permissions permissions
    if self.permissions_changed?(permissions)
      self.permissions = permissions
      self.save
    end
  end

  def apply_default_permissions
    self.permissions = [
      {:type => "group", :name => "archivist",    :access => "edit"},
      {:type => "group", :name => "reviewer",     :access => "edit"},
      {:type => "group", :name => "donor",        :access => "read"},
      {:type => "user",  :name => self.depositor, :access => "edit"}
    ]
    self.save
  end

end