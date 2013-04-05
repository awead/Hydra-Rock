module Rockhall::Conversion

  # Converts our old models to new ones.  Old ArchivalVideo and DigitalVideo objects are merged into
  # one kind of new ArchivalVideo object.  Old ArchivalVideo objects are reorganized to have no
  # instantiations and instead have them linked as related objects.  All objects have pboreRelation
  # nodes for collection  and series removed, and saved to the properties datastream.  Xml
  # validation errors are corrected, and ExternalVideos are simplified to only inlcude the
  # pbcoreInstantiation node and no parent nodes.

  # Converts an old ArchivalVideo model to the new one
  #  - captures the old collection number field and save that to the properties datastream for later
  #    use to link with archival collections
  #  - removes the exsiting pbcoreInstantation and creates new ExternalVideo object using the xml
  #  - removes pbcoreRelation nodes for archival collections and series
  #  - cleans up xml validation errors
  #  - returns the new ExternalVideo object and does not save anything
  def from_archival_video ev = ExternalVideo.new, dep_ds = HydraPbcore::Datastream::Deprecated::Document.new
    dep_ds.ng_xml = self.datastreams["descMetadata"].ng_xml
    xml = self.datastreams["descMetadata"].to_document
    doc = Nokogiri::XML::Document.parse(xml.to_s)
    
    self.datastreams["descMetadata"].clean_document
    self.collection_number = dep_ds.collection_number
    
    ev.datastreams["descMetadata"].ng_xml = doc
    ev.datastreams["descMetadata"].to_physical_instantiation
    return ev
  end


  # Converts existing DigitalVideo object to new ArchivalVideo object
  def from_digital_video
  end


  # Converts existing ExternalVideo to new ExternalVideo object
  def from_external_video
  end



end
