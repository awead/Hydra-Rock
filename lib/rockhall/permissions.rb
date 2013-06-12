module Rockhall::Permissions

  include Hydra::ModelMixins::RightsMetadata

  def update_permissions permissions
    self.permissions = permissions
    self.save
  end

  def apply_default_permissions
    self.permissions = [
      {:type => "group", :name => "archivist",    :access => "edit"},
      {:type => "group", :name => "donor",        :access => "read"},
      {:type => "user",  :name => self.depositor, :access => "edit"}
    ]
    self.save
  end

end