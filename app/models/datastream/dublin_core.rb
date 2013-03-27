class DublinCore < ActiveFedora::NokogiriDatastream

  set_terminology do |t|
    t.root(:path=>"dc", :namespace_prefix=>"dc")
    t.contributor(:path=>"dc:contributor")
    t.coverage(:path=>"dc:coverage")
    t.creator(:path=>"dc:creator")
    t.date(:path=>"dc:date")
    t.description(:path=>"dc:description")
    t.format(:path=>"dc:format")
    t.identifier(:path=>"dc:identifier")
    t.language(:path=>"dc:language")
    t.publisher(:path=>"dc:publisher")
    t.relation(:path=>"dc:relation")
    t.rights(:path=>"dc:rights")
    t.source(:path=>"dc:source")
    t.subject(:path=>"dc:subject")
    t.title(:path=>"dc:title")
    t.type(:path=>"dc:type")
  end

  def self.xml_template
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.dc("xmlns:dc" => "http://purl.org/dc/elements/1.1/", "xmlns:dct" => "http://purl.org/dc/terms/")
    end
    return builder.doc
  end

end