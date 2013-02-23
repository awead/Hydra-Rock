module Rockhall::Conversion

  # Converts our old models to new ones.  Old ArchivalVideo and DigitalVideo objects are merged into one
  # kind of new ArchivalVideo object.  Old ArchivalVideo objects are reorganized to have no instantiations
  # and instead have them linked as related objects.  All objects have pboreRelation nodes for collection 
  # and series removed, replaced with linked objects for ArchivalCollection and ArchivalSeries.  Xml validation
  # errors are corrected, and ExternalVideos are simplified to only inlcude the pbcoreInstantiation node and
  # no parent nodes.

  # Converts an old ArchivalVideo model to new one.
  #  - removes pbcoreInstantation and created new linked ExternalVideo object
  #  - removes pbcoreRelation nodes for archival collections and series, creates appropriate linked objects
  #  - cleans up xml validation errors
  def from_archival_video
    inst = self.datastreams["descMetadata"].to_document
    # video = ExternalVideo.new
    # video.datastreams["descMetadata"] = video
    # link up video with self
    # link up self/video with ArchivalCollection and ArchivalSeries
    # video.datastreams["descMetadata"].to_physical_instantiation
    self.datastreams["descMetadata"].clean_document
    self.save
  end


  # Converts existing DigitalVideo object to new ArchivalVideo object
  def from_digital_video
  end


  # Converts existing ExternalVideo to new ExternalVideo object
  def from_external_video
  end



end
