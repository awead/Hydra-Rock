class RockhallDocument < HydraPbcore::Datastream::Deprecated::Document

  include Rockhall::WorkflowMethods

  @terminology = HydraPbcore::Datastream::Deprecated::Document.terminology

  def to_solr(solr_doc = Hash.new)
    super(solr_doc)
    solr_doc.merge!({"format" => "Video"})

    # TODO: map PBcore's three-letter language codes to full language names
    # Right now, everything's English.
    if self.find_by_terms(:language).text.match("eng")
      solr_doc.merge!(:language_facet => "English")
    else
      solr_doc.merge!(:language_facet => "Unknown")
    end

    # Extract 4-digit year for creation date facet in Hydra and pub_date facet in Blacklight
    create = self.find_by_terms(:creation_date).text.strip
    unless create.nil? or create.empty?
      solr_doc.merge!(:create_date_facet => get_year(create))
      solr_doc.merge!(:pub_date => get_year(create))
    end
    return solr_doc
  end

end