class AssetReview < ActiveFedora::OmDatastream

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
    Solrizer.insert_field(solr_doc, "complete", "no",     :facetable, :displayable) if self.find_by_terms(:complete).nil?
    Solrizer.insert_field(solr_doc, "priority", "normal", :facetable, :displayable) if self.find_by_terms(:priority).nil?

    return solr_doc
  end

end