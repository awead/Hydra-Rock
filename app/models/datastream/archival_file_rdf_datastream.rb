class ArchivalFileRdfDatastream < RDF::EbuCore::Datastream
  map_predicates do |map|
    map.title(:in=> RDF::DC) do |index|
      index.as :searchable, :displayable
    end

    map.date_uploaded(:to => "dateSubmitted", in: RDF::DC) do |index|
      index.type :date
      index.as :stored_sortable
    end
  end

  # Overrides ActiveFedora::RDFDatastream#prefix to not prefix the solr field
  # with the dsid.  Ex. whereas Sufia would normally create the field:
  #   desc_metadata__title_ssm
  # This returns the field:
  #    title_ssm
  # So it matches with other solr fields created with OM.
  def prefix name
    return name
  end

end
