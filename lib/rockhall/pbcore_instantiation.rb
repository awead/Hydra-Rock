module Rockhall
class PbcoreInstantiation < ActiveFedora::NokogiriDatastream

	include Rockhall::PbcoreMethods

  # Note: this is not a complete PBcore document, just an instantiation node
  set_terminology do |t|
    t.root(:path=>"pbcoreDescriptionDocument", :xmlns=>"http://www.pbcore.org/PBCore/PBCoreNamespace.html", :schema=>"http://www.pbcore.org/PBCore/PBCoreNamespace.html")

    t.inst(:path=>"pbcoreInstantiation") {

      t.inst_name(:path=>"instantiationIdentifier", :attributes=>{ :source=>"rockhall", :annotation=>"file name" })
      t.inst_date(:path=>"instantiationDate", :attributes=>{ :dateType=>"created" })
      t.inst_generation(:path=>"instantiationGenerations", :attributes=>{ :source=>"PBCore instantiationGenerations" }) {
        t.ref(:path=>{:attribute=>"ref"})
      }

      t.inst_type(:path=>"instantiationDigital")

      t.inst_size(:path=>"instantiationFileSize") {
        t.units(:path=>{:attribute=>"unitsOfMeasure"})
      }

      t.inst_rate(:path=>"instantiationDataRate") {
        t.units(:path=>{:attribute=>"unitsOfMeasure"})
      }

      t.inst_colors(:path=>"instantiationColors", :attributes=>{ :source=>"PBCore instantiationColors" }) {
        t.ref(:path=>{:attribute=>"ref"})
      }

      t.inst_duration(:path=>"instantiationDuration")

      t.inst_link(:path=>"instantiationLocation")

      t.inst_rights(:path=>"instantiationRights") {
        t.summary(:path=>"rightsSummary")
        t.link(:path=>"rightsLink")
      }

      t.inst_note(:path=>"instantiationAnnotation", :attributes=>{ :annotationType=>"note" })

    }

    # Flatten it out a bit...
    t.name(:ref=>[:inst, :inst_name])
    t.date(:ref=>[:inst, :inst_date])
    t.generation(:ref=>[:inst, :inst_generation]) {
      t.ref(:ref=>[:inst, :inst_generation, :ref])
    }
    t.type_(:ref=>[:inst, :inst_type])
    t.size(:ref=>[:inst, :inst_size]) {
      t.units(:ref=>[:inst, :inst_size, :units])
    }
    t.rate(:ref=>[:inst, :inst_rate]) {
      t.units(:ref=>[:inst, :inst_rate, :units])
    }
    t.colors(:ref=>[:inst, :inst_colors]) {
      t.ref(:ref=>[:inst, :inst_colors, :ref])
    }
    t.duration(:ref=>[:inst, :inst_duration])
    t.link(:ref=>[:inst, :inst_link])
    t.rights_summary(:ref=>[:inst, :inst_rights, :summary])
    t.rights_link(:ref=>[:inst, :inst_rights, :link])
    t.note(:ref=>[:inst, :inst_note])

  end

  def self.xml_template
    builder = Nokogiri::XML::Builder.new do |xml|

      xml.pbcoreDescriptionDocument(:version=>"2.0", "xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
        "xmlns"=>"http://www.pbcore.org/PBCore/PBCoreNamespace.html",
        "xsi:schemaLocation"=>"http://www.pbcore.org/PBCore/PBCoreNamespace.html") {

        xml.pbcoreInstantiation {

          xml.instantiationIdentifier(:source=>"rockhall", :annotation=>"file name")
          xml.instantiationFileSize(:unitsOfMeasure=>"")
          xml.instantiationDataRate(:unitsOfMeasure=>"")
          xml.instantiationDate(:dateType=>"created")
          xml.instantiationDigital(:source=>"EBU file formats", :ref=>"http://www.ebu.ch/metadata/cs/web/ebu_FileFormatCS_p.xml.htm")
          xml.instantiationLocation
          xml.instantiationGenerations(:source=>"PBCore instantiationGenerations", :ref=>"")
          xml.instantiationColors(:source=>"PBCore instantiationColors", :ref=>"")
          xml.instantiationDuration

          xml.instantiationRights {
            xml.rightsSummary
            xml.rightsLink
          }

        }

      }

    end
    return builder.doc
  end

end
end