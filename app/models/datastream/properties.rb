class Properties < ActiveFedora::OmDatastream

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
    Solrizer.insert_field(solr_doc, "depositor",           self.find_by_terms(:depositor).text,  :facetable, :displayable) unless self.find_by_terms(:depositor).nil?
    Solrizer.insert_field(solr_doc, "converted",           self.find_by_terms(:converted).text,  :facetable, :displayable) unless self.find_by_terms(:converted).nil?
    Solrizer.insert_field(solr_doc, "internal_series",     self.find_by_terms(:series).text,     :facetable, :displayable) unless self.find_by_terms(:series).nil?
    Solrizer.insert_field(solr_doc, "internal_collection", self.find_by_terms(:collection).text, :facetable, :displayable) unless self.find_by_terms(:collection).nil?

    return solr_doc
  end

end