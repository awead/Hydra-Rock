class PbcoreDocument < HydraPbcore::Datastream::Document

  @terminology = HydraPbcore::Datastream::Document.terminology

  def to_solr(solr_doc = Hash.new)
    super(solr_doc)
    solr_doc.merge!({"format" => "Video"})
  end


end