module Rockhall
class AssetReview < ActiveFedora::NokogiriDatastream

  set_terminology do |t|
    t.root(:path=>"fields", :namespace_prefix=>nil)
    t.reviewer
    t.date_updated
    t.complete
    t.abstract
    t.license
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
      }
    end
    return builder.doc
  end

end
end