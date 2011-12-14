module Rockhall
class Pbcore

  # This module is a work in progress

  # Nokogiri's add_namespace doesn't seem to work, so we have to insert it "manually"
  def self.insert_pbcore_namespace(doc)
    index = doc.to_s.index("xmlns:xsi")
    new_s = doc.to_s.insert(index.to_i, 'xmlns="http://www.pbcore.org/PBCore/PBCoreNamespace.html" ')
    new_doc = Nokogiri::XML(new_s)
    return new_doc
  end

  # Validates a PBCore document against an xsd
  # Returns an array of errors -- an empty array means it's valid
  def self.validate(doc)
    xsd = Nokogiri::XML::Schema(open("http://pbcore.org/xsd/pbcore-2.0.xsd"))
    xsd.validate(doc)
  end


  # Reorders the nodes of pbcoreDescriptionDocument to conform with the correct order
  def self.reorder_document(doc)

    nodes = [
      "pbcoreAssetType",
      "pbcoreAssetDate",
      "pbcoreIdentifier",
      "pbcoreTitle",
      "pbcoreSubject",
      "pbcoreDescription",
      "pbcoreGenre",
      "pbcoreRelation",
      "pbcoreCoverage",
      "pbcoreAudienceLevel",
      "pbcoreAudienceRating",
      "pbcoreCreator",
      "pbcoreContributor",
      "pbcorePublisher",
      "pbcoreRightsSummary",
      "pbcoreInstantiation",
      "pbcoreAnnotation",
      "pbcorePart",
      "pbcoreExtension",
    ]

    blank = '<?xml version="1.0"?><pbcoreDescriptionDocument xmlns="http://www.pbcore.org/PBCore/PBCoreNamespace.html" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.pbcore.org/PBCore/PBCoreNamespace.html" xsi:schemaLocation="http://www.pbcore.org/PBCore/PBCoreNamespace.html"></pbcoreDescriptionDocument>'
    new_doc = Nokogiri::XML(blank)

    nodes.each do |node|
      doc.search(node).each do |n|
        new_doc.root.add_child(n)
      end
    end

    return new_doc
  end

end
end
