# A Blacklight::Solr::Document::Extension that allows us to export Hydra objects in different formats
# 
# By calling .xml at the end of any catalog url, the .to_pbcore_method is called on the underlying
# object.  The method must be defined at the model level for each/all models. See:
#   Rockhall::ModelMethods.to_pbcore_xml
# Note: this overrides Blacklight's default behavior which exports opensearch xml when the .xml
# format is called.
module Rockhall::Exports
  def self.extended(document)
    Rockhall::Exports.register_export_formats( document )
  end

  def self.register_export_formats(document)
    document.will_export_as(:xml, "text/xml")
  end

  def export_as_pbcore_xml
    ActiveFedora::Base.find(@_source["id"], :cast => true).to_pbcore_xml
  end

  # This will override Blacklight's default of exporting .xml as opensearch xml 
  alias_method :export_as_xml, :export_as_pbcore_xml

end
