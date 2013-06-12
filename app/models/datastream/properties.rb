class Properties < ActiveFedora::NokogiriDatastream

  set_terminology do |t|
    t.root(:path=>"fields", :namespace_prefix=>nil)
    t.collection # collection number from hydra-pbcore v1 datastreams
    t.series     # archival series field from hydra-pbocore v1 datastreams
    t.depositor
    t.notes
    t.access
    t.submission
    t.converted  # returns true/false if the model was successfully converted; default is nil
  end

  def self.xml_template
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.fields {
        xml.collection
        xml.series
        xml.depositor
        xml.notes
        xml.access
        xml.submission
        xml.converted
      }
    end
    return builder.doc
  end

  def to_solr(solr_doc=Solr::Document.new)
    super(solr_doc)

    # Facets
    unless self.find_by_terms(:depositor).nil?
      solr_doc.merge!(:depositor_facet => self.find_by_terms(:depositor).text)
    end
    unless self.find_by_terms(:converted).nil?
      solr_doc.merge!(:converted_facet => self.find_by_terms(:converted).text)
    end
    unless self.find_by_terms(:series).nil?
      solr_doc.merge!(:internal_series_facet => self.find_by_terms(:series).text)
    end
    unless self.find_by_terms(:collection).nil?
      solr_doc.merge!(:internal_collection_facet => self.find_by_terms(:collection).text)
    end

    return solr_doc
  end

end