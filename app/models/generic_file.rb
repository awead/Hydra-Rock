class GenericFile < ActiveFedora::Base
  include Sufia::GenericFile

  #has_metadata :name => "descMetadata", :type => ArchivalFileRdfDatastream

end