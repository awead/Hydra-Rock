class DublinCore < ActiveFedora::OmDatastream

  set_terminology do |t|
    t.root(:path=>"dc", :namespace_prefix=>"dc")
    t.contributor(:path=>"dc:contributor", :index_as => [:searchable, :displayable])
    t.coverage(:path=>"dc:coverage", :index_as => [:searchable, :displayable])
    t.creator(:path=>"dc:creator", :index_as => [:searchable, :displayable])
    t.date(:path=>"dc:date", :index_as => [:searchable, :displayable])
    t.description(:path=>"dc:description", :index_as => [:searchable, :displayable])
    t.format(:path=>"dc:format", :index_as => [:searchable, :displayable])
    t.identifier(:path=>"dc:identifier", :index_as => [:searchable, :displayable])
    t.language(:path=>"dc:language", :index_as => [:searchable, :displayable])
    t.publisher(:path=>"dc:publisher", :index_as => [:searchable, :displayable])
    t.relation(:path=>"dc:relation", :index_as => [:searchable, :displayable])
    t.rights(:path=>"dc:rights", :index_as => [:searchable, :displayable])
    t.source(:path=>"dc:source", :index_as => [:searchable, :displayable])
    t.subject(:path=>"dc:subject", :index_as => [:searchable, :displayable])
    t.title(:path=>"dc:title", :index_as => [:searchable, :displayable])
    t.type(:path=>"dc:type", :index_as => [:searchable, :displayable])
  end

  def self.xml_template
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.dc("xmlns:dc" => "http://purl.org/dc/elements/1.1/", "xmlns:dct" => "http://purl.org/dc/terms/")
    end
    return builder.doc
  end

end