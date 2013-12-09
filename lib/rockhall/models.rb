module Rockhall::Models
  extend ActiveSupport::Concern

  include Rockhall::Models::Collections
  include Rockhall::Models::VideoFiles
  include Rockhall::Models::Permissions
  include Rockhall::Models::Reorganize
  include Rockhall::Models::Templates
  include Rockhall::Models::Validations

  # Adds depositor information
  def apply_depositor_metadata depositor_id
    self.depositor = depositor_id
    self.rightsMetadata.permissions({:person=>depositor_id}, 'edit') unless self.rightsMetadata.nil?
  end

  # returns a complete pbcore xml document
  def to_pbcore_xml instantiations = Array.new
    unless self.external_videos.nil?
      self.external_videos.collect { |v| instantiations << v.datastreams["descMetadata"] }
    end
    self.datastreams["descMetadata"].pbc_id = self.pid
    self.datastreams["descMetadata"].to_pbcore_xml(instantiations)
  end

  def valid_pbcore?
    HydraPbcore.is_valid?(self.to_pbcore_xml)
  end

end