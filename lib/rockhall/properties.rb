module Rockhall
class Properties < ActiveFedora::NokogiriDatastream

  set_terminology do |t|
    t.root(:path=>"fields", :namespace_prefix=>nil)
    t.collection # TODO: need to remove this field from all objects
    t.depositor
    t.notes
    t.access
    t.submission
  end

  def self.xml_template
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.fields {
        xml.collection
        xml.depositor
        xml.notes
        xml.access
        xml.submission
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

    return solr_doc
  end

end
end