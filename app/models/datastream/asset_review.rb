class AssetReview < ActiveFedora::NokogiriDatastream

  set_terminology do |t|
    t.root(:path=>"fields", :namespace_prefix=>nil)
    t.reviewer(:index_as => [:facetable])
    t.date_updated(:index_as => [:displayable])
    t.complete(:index_as => [:facetable])
    t.abstract(:index_as => [:displayable])
    t.license(:index_as => [:displayable])
    t.priority(:index_as => [:facetable])
  end

  def self.xml_template
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.fields {
        xml.reviewer
        xml.date_updated
        xml.complete {
          xml.text "no"
        }
        xml.abstract
        xml.license
        xml.priority {
         xml.text "normal"
        }
      }
    end
    return builder.doc
  end

  def to_solr(solr_doc=Solr::Document.new)
    super(solr_doc)

    # DAM-168: Default values for asset_review fields
    # These fields were added later, so existing objects don't have them.  Here we set their
    # values to defaults.
    if self.find_by_terms(:complete).nil?
      solr_doc.merge!(:complete_facet => "no")
    end
    if self.find_by_terms(:priority).nil?
      solr_doc.merge!(:priority_facet => "normal")
    end

    return solr_doc
  end

end