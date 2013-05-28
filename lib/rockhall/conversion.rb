module Rockhall::Conversion

  # Converts our old models to new ones.  Old ArchivalVideo and DigitalVideo objects are merged into
  # one kind of new ArchivalVideo object.  Old ArchivalVideo objects are reorganized to have no
  # instantiations and instead have them linked as related objects.  All objects have pboreRelation
  # nodes for collection  and series removed, and saved to the properties datastream.  Xml
  # validation errors are corrected, and ExternalVideos are simplified to only inlcude the
  # pbcoreInstantiation node and no parent nodes.

  # Converts an old ArchivalVideo model to the new one
  #  - captures the old collection number, collection name and accession fields 
  #  - saves the collection number to a properties datastream for later use
  #  - removes the exsiting pbcoreInstantation and creates new ExternalVideo object using the xml
  #  - removes pbcoreRelation nodes for archival collections and series, copy the collections field
  #    to the additional_collection field, copy previous accession number field to new node
  #  - cleans up xml validation errors
  #  - returns the new ExternalVideo object and does not save anything
  def from_archival_video ev = ExternalVideo.new, dep_ds = HydraPbcore::Datastream::Deprecated::Document.new
    dep_ds.ng_xml = self.descMetadata.ng_xml
    xml = self.descMetadata.to_document
    doc = Nokogiri::XML::Document.parse(xml.to_s)
    
    self.descMetadata.clean_document
    self.collection_number = dep_ds.collection_number
    self.archival_series   = dep_ds.archival_series
    self.new_collection({:name => dep_ds.collection.first}) unless dep_ds.collection.nil?
    self.new_accession({:name => dep_ds.accession_number.first}) unless dep_ds.accession_number.nil?
    
    ev.descMetadata.ng_xml = doc
    ev.descMetadata.to_physical_instantiation
    return ev
  end


  # Converts existing DigitalVideo object to new ArchivalVideo object
  #  - cleans up the xml, as defined in HydraPbcore
  #  - captures any collection number or archival series fields and saves them to the
  #    properies datastream
  #  - clones the existing object into a new ArchivalVideo with the same pid
  def from_digital_video ds = HydraPbcore::Datastream::Document.new
    raise "Only converts DigitalVideo objects" unless self.is_a? DigitalVideo
    ds.ng_xml = self.descMetadata.ng_xml
    av = ArchivalVideo.new(:pid => self.pid)
    self.descMetadata.clean_digital_document
    self.clone_into av
    av.collection_number = ds.collection_number.first
    av.archival_series   = ds.archival_series.first
    return av
  end


  # Converts existing ExternalVideo to new ExternalVideo object
  def from_external_video
    raise "Only converts ExternalVideo objects" unless self.is_a? ExternalVideo
    self.descMetadata.to_instantiation
  end

end
