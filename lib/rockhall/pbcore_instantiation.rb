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

      t.inst_file_format(:path=>"instantiationDigital", :attributes=>{ :source=>"EBU file formats" })

      t.inst_size(:path=>"instantiationFileSize") {
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

      # Instantitation annotiations
      t.inst_chksum_type(:path=>"instantiationAnnotation", :attributes=>{ :annotationType=>"checksum type" })
      t.inst_chksum_value(:path=>"instantiationAnnotation", :attributes=>{ :annotationType=>"checksum value" })
      t.inst_device(:path=>"instantiationAnnotation", :attributes=>{ :annotationType=>"playback device" })
      t.inst_capture_soft(:path=>"instantiationAnnotation", :attributes=>{ :annotationType=>"capture software" })
      t.inst_trans_soft(:path=>"instantiationAnnotation", :attributes=>{ :annotationType=>"transcoding software" })
      t.inst_operator(:path=>"instantiationAnnotation", :attributes=>{ :annotationType=>"operator" })
      t.inst_trans_note(:path=>"instantiationAnnotation", :attributes=>{ :annotationType=>"transfer notes" })
      t.inst_vendor(:path=>"instantiationAnnotation", :attributes=>{ :annotationType=>"vendor name" })
      t.inst_cond_note(:path=>"instantiationAnnotation", :attributes=>{ :annotationType=>"condition notes" })
      t.inst_clean_note(:path=>"instantiationAnnotation", :attributes=>{ :annotationType=>"cleaning notes" })
      t.inst_note(:path=>"instantiationAnnotation", :attributes=>{ :annotationType=>"note" })
      t.inst_color_space(:path=>"instantiationAnnotation", :attributes=>{ :annotationType=>"color space" })
      t.inst_chroma(:path=>"instantiationAnnotation", :attributes=>{ :annotationType=>"chroma" })

      # Essence track information
      t.essence(:path=>"instantiationEssenceTrack") {
        t.type_(:path=>"essenceTrackType", :attributes=>{ :source=>"PBCore essenceTrackType" })
        t.standard(:path=>"essenceTrackStandard")
        t.encoding(:path=>"essenceTrackEncoding", :attributes=>{ :source=>"PBCore essenceTrackEncoding" })
        t.bit_rate(:path=>"essenceTrackDataRate") {
          t.unit(:path=>{:attribute=>"unitsOfMeasure"})
        }
        t.frame_rate(:path=>"essenceTrackFrameRate", :attributes=>{ :unitsOfMeasure=>"fps" })
        t.frame_size(:path=>"essenceTrackFrameSize", :attributes=>{ :source=>"PBcore essenceTrackFrameSize" })
        t.sample_rate(:path=>"essenceTrackSamplingRate") {
          t.unit(:path=>{:attribute=>"unitsOfMeasure" })
        }
        t.bit_depth(:path=>"essenceTrackBitDepth")
        t.ratio(:path=>"essenceTrackAspectRatio", :attributes=>{ :source=>"PBcore essenceTrackAspectRatio" })
        t.audio_channels(:path=>"essenceAnnotation", :attributes=>{ :annotationType=>"number of audio channels" })
      }

    }

    # Flatten it out a bit...
    t.name(:ref=>[:inst, :inst_name])
    t.date(:ref=>[:inst, :inst_date])
    t.generation(:ref=>[:inst, :inst_generation]) {
      t.ref(:ref=>[:inst, :inst_generation, :ref])
    }
    t.file_format(:ref=>[:inst, :inst_file_format])
    t.size(:ref=>[:inst, :inst_size]) {
      t.units(:ref=>[:inst, :inst_size, :units])
    }
    t.colors(:ref=>[:inst, :inst_colors]) {
      t.ref(:ref=>[:inst, :inst_colors, :ref])
    }
    t.duration(:ref=>[:inst, :inst_duration])
    t.link(:ref=>[:inst, :inst_link])
    t.rights_summary(:ref=>[:inst, :inst_rights, :summary])
    t.rights_link(:ref=>[:inst, :inst_rights, :link])
    t.note(:ref=>[:inst, :inst_note])
    t.chksum_type(:ref=>[:inst, :inst_chksum_type])
    t.chksum_value(:ref=>[:inst, :inst_chksum_value])
    t.device(:ref=>[:inst, :inst_device])
    t.capture_soft(:ref=>[:inst, :inst_capture_soft])
    t.trans_soft(:ref=>[:inst, :inst_trans_soft])
    t.operator(:ref=>[:inst, :inst_operator])
    t.trans_note(:ref=>[:inst, :inst_trans_note])
    t.vendor(:ref=>[:inst, :inst_vendor])
    t.condition(:ref=>[:inst, :inst_cond_note])
    t.cleaning(:ref=>[:inst, :inst_clean_note])
    t.color_space(:ref=>[:inst, :inst_color_space])
    t.chroma(:ref=>[:inst, :inst_chroma])

    # Video essence fields
    # TODO proxy and path methods (see http://hudson.projecthydra.org/job/om/Documentation/file.COMMON_OM_PATTERNS.html)
    #t.video_codec ?? [{:inst=>0}, {:essence=>0}, :codec] for now
    #t.audio_codec ?? [{:inst=>0}, {:essence=>1}, :codec] for now
    #t.video_bit_rate
    #t.audio_bit_rate


  end

  def self.xml_template
    builder = Nokogiri::XML::Builder.new do |xml|

      xml.pbcoreDescriptionDocument(:version=>"2.0", "xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
        "xmlns"=>"http://www.pbcore.org/PBCore/PBCoreNamespace.html",
        "xsi:schemaLocation"=>"http://www.pbcore.org/PBCore/PBCoreNamespace.html") {

        xml.pbcoreInstantiation {

          xml.instantiationIdentifier(:source=>"rockhall", :annotation=>"file name")
          xml.instantiationFileSize(:unitsOfMeasure=>"")
          xml.instantiationDate(:dateType=>"created")
          xml.instantiationDigital(:source=>"EBU file formats", :ref=>"http://www.ebu.ch/metadata/cs/web/ebu_FileFormatCS_p.xml.htm")
          xml.instantiationGenerations(:source=>"PBCore instantiationGenerations", :ref=>"")
          xml.instantiationColors(:source=>"PBCore instantiationColors", :ref=>"")
          xml.instantiationDuration

          xml.instantiationRights {
            xml.rightsSummary
            xml.rightsLink
          }

          xml.instantiationEssenceTrack {
            xml.essenceTrackType(:source=>"PBCore essenceTrackType") {
              xml.text "Video"
            }
            xml.essenceTrackStandard
            xml.essenceTrackEncoding(:source=>"PBCore essenceTrackEncoding")
            xml.essenceTrackDataRate(:unitsOfMeasure=>"")
            xml.essenceTrackFrameRate(:unitsOfMeasure=>"fps")
            xml.essenceTrackFrameSize(:source=>"PBcore essenceTrackFrameSize")
            xml.essenceTrackBitDepth
            xml.essenceTrackAspectRatio(:source=>"PBcore essenceTrackAspectRatio")
          }

          xml.instantiationEssenceTrack {
            xml.essenceTrackType(:source=>"PBCore essenceTrackType") {
              xml.text "Audio"
            }
            xml.essenceTrackStandard
            xml.essenceTrackEncoding(:source=>"PBCore essenceTrackEncoding")
            xml.essenceTrackDataRate(:unitsOfMeasure=>"")
            xml.essenceTrackSamplingRate(:unitsOfMeasure=>"")
            xml.essenceTrackBitDepth
            xml.essenceAnnotation(:annotationType=>"number of audio channels")
          }

        }

      }

    end
    return builder.doc
  end

end
end
