module Rockhall
class PbcoreInstantiation < ActiveFedora::NokogiriDatastream

  include Rockhall::PbcoreMethods

  # Note: this is not a complete PBCore document, just an instantiation node
  set_terminology do |t|
    t.root(:path=>"pbcoreDescriptionDocument", :xmlns => '', :namespace_prefix=>nil)

    t.pbcoreInstantiation(:namespace_prefix=>nil) {

      t.instantiationIdentifier(:namespace_prefix=>nil, :attributes=>{ :annotation=>"Filename", :source=>"Rock and Roll Hall of Fame and Museum" })
      t.instantiationDate(:namespace_prefix=>nil, :attributes=>{ :dateType=>"created" })
      t.instantiationDigital(:namespace_prefix=>nil, :attributes=>{ :source=>"EBU file formats" })
      t.instantiationLocation(:namespace_prefix=>nil)
      t.instantiationGenerations(:namespace_prefix=>nil, :attributes=>{ :source=>"PBCore instantiationGenerations" })
      t.instantiationFileSize(:namespace_prefix=>nil) {
        t.units(:path=>{:attribute=>"unitsOfMeasure"}, :namespace_prefix=>nil)
      }
      t.instantiationColors(:namespace_prefix=>nil, :attributes=>{ :source=>"PBCore instantiationColors" })
      t.instantiationMediaType(:namespace_prefix=>nil, :attributes=>{ :source=>"PBCore instantiationMediaType" })
      t.instantiationDuration(:namespace_prefix=>nil)

      t.instantiationRights(:namespace_prefix=>nil) {
        t.rightsSummary(:namespace_prefix=>nil)
      }

      t.instantiationEssenceTrack(:namespace_prefix=>nil) {
        t.essenceTrackStandard(:namespace_prefix=>nil)
        t.essenceTrackEncoding( :namespace_prefix=>nil, :attributes=>{ :source=>"PBCore essenceTrackEncoding" })
        t.essenceTrackDataRate(:namespace_prefix=>nil) {
          t.units(:path=>{:attribute=>"unitsOfMeasure"}, :namespace_prefix=>nil)
        }
        t.essenceTrackFrameRate(:namespace_prefix=>nil, :attributes=>{ :unitsOfMeasure=>"fps" })
        t.essenceTrackFrameSize(:namespace_prefix=>nil, :attributes=>{ :source=>"PBCore essenceTrackFrameSize" })
        t.essenceTrackBitDepth(:namespace_prefix=>nil)
        t.essenceTrackAspectRatio(:namespace_prefix=>nil, :attributes=>{ :source=>"PBCore essenceTrackAspectRatio" })
        t.essenceTrackSamplingRate(:namespace_prefix=>nil) {
          t.units(:path=>{:attribute=>"unitsOfMeasure"}, :namespace_prefix=>nil)
        }
        t.essenceTrackAnnotation( :namespace_prefix=>nil, :attributes=>{ :annotationType=>"Number of Audio Channels" })
      }
      t.video_essence(:ref => [:pbcoreInstantiation, :instantiationEssenceTrack],
        :path=>'instantiationEssenceTrack[essenceTrackType="Video"]',
        :namespace_prefix=>nil
      )
      t.audio_essence(:ref => [:pbcoreInstantiation, :instantiationEssenceTrack],
        :path=>'instantiationEssenceTrack[essenceTrackType="Audio"]',
        :namespace_prefix=>nil
      )

      # Instantitation annotiations
      t.inst_chksum_type(:path=>"instantiationAnnotation", :namespace_prefix=>nil, :attributes=>{ :annotationType=>"Checksum Type" })
      t.inst_chksum_value(:path=>"instantiationAnnotation", :namespace_prefix=>nil, :attributes=>{ :annotationType=>"Checksum Value" })
      t.inst_device(:path=>"instantiationAnnotation", :namespace_prefix=>nil, :attributes=>{ :annotationType=>"Playback Device" })
      t.inst_capture_soft(:path=>"instantiationAnnotation", :namespace_prefix=>nil, :attributes=>{ :annotationType=>"Capture Software" })
      t.inst_trans_soft(:path=>"instantiationAnnotation", :namespace_prefix=>nil, :attributes=>{ :annotationType=>"Transcoding Software" })
      t.inst_operator(:path=>"instantiationAnnotation", :namespace_prefix=>nil, :attributes=>{ :annotationType=>"Operator" })
      t.inst_trans_note(:path=>"instantiationAnnotation", :namespace_prefix=>nil, :attributes=>{ :annotationType=>"Transfer Notes" })
      t.inst_vendor(:path=>"instantiationAnnotation", :namespace_prefix=>nil, :attributes=>{ :annotationType=>"Vendor Name" })
      t.inst_cond_note(:path=>"instantiationAnnotation", :namespace_prefix=>nil, :attributes=>{ :annotationType=>"Condition Notes" })
      t.inst_clean_note(:path=>"instantiationAnnotation", :namespace_prefix=>nil, :attributes=>{ :annotationType=>"Cleaning Notes" })
      t.inst_note(:path=>"instantiationAnnotation", :namespace_prefix=>nil, :attributes=>{ :annotationType=>"Notes" })
      t.inst_color_space(:path=>"instantiationAnnotation", :namespace_prefix=>nil, :attributes=>{ :annotationType=>"Color Space" })
      t.inst_chroma(:path=>"instantiationAnnotation", :namespace_prefix=>nil, :attributes=>{ :annotationType=>"Chroma" })

    }

    #
    # Here are the actual references to the fields
    #

    t.name(:proxy=>[:pbcoreInstantiation, :instantiationIdentifier])
    t.location(:proxy=>[:pbcoreInstantiation, :instantiationLocation])
    t.date(:proxy=>[:pbcoreInstantiation, :instantiationDate])
    t.generation(:proxy=>[:pbcoreInstantiation, :instantiationGenerations])
    t.media_type(:proxy=>[:pbcoreInstantiation, :instantiationMediaType])
    t.file_format(:proxy=>[:pbcoreInstantiation, :instantiationDigital])
    t.size(:proxy=>[:pbcoreInstantiation, :instantiationFileSize])
    t.size_units(:proxy=>[:pbcoreInstantiation, :instantiationFileSize, :units])
    t.colors(:proxy=>[:pbcoreInstantiation, :instantiationColors])
    t.duration(:proxy=>[:pbcoreInstantiation, :instantiationDuration])
    t.rights_summary(:proxy=>[:pbcoreInstantiation, :instantiationRights, :rightsSummary])

    # Proxies to annotation fields
    # These are also all inserted fields and are not in the template
    t.note(:proxy=>[:pbcoreInstantiation, :inst_note])
    t.checksum_type(:proxy=>[:pbcoreInstantiation, :inst_chksum_type])
    t.checksum_value(:proxy=>[:pbcoreInstantiation, :inst_chksum_value])
    t.device(:proxy=>[:pbcoreInstantiation, :inst_device])
    t.capture_soft(:proxy=>[:pbcoreInstantiation, :inst_capture_soft])
    t.trans_soft(:proxy=>[:pbcoreInstantiation, :inst_trans_soft])
    t.operator(:proxy=>[:pbcoreInstantiation, :inst_operator])
    t.trans_note(:proxy=>[:pbcoreInstantiation, :inst_trans_note])
    t.vendor(:proxy=>[:pbcoreInstantiation, :inst_vendor])
    t.condition(:proxy=>[:pbcoreInstantiation, :inst_cond_note])
    t.cleaning(:proxy=>[:pbcoreInstantiation, :inst_clean_note])
    t.color_space(:proxy=>[:pbcoreInstantiation, :inst_color_space])
    t.chroma(:proxy=>[:pbcoreInstantiation, :inst_chroma])

    # Proxies to video essence fields
    t.video_standard(:proxy=>[:pbcoreInstantiation, :video_essence, :essenceTrackStandard])
    t.video_encoding(:proxy=>[:pbcoreInstantiation, :video_essence, :essenceTrackEncoding])
    t.video_bit_rate(:proxy=>[:pbcoreInstantiation, :video_essence, :essenceTrackDataRate])
    t.video_bit_rate_units(:proxy=>[:pbcoreInstantiation, :video_essence, :essenceTrackDataRate, :units])
    t.frame_rate(:proxy=>[:pbcoreInstantiation, :video_essence, :essenceTrackFrameRate])
    t.frame_size(:proxy=>[:pbcoreInstantiation, :video_essence, :essenceTrackFrameSize])
    t.video_bit_depth(:proxy=>[:pbcoreInstantiation, :video_essence, :essenceTrackBitDepth])
    t.aspect_ratio(:proxy=>[:pbcoreInstantiation, :video_essence, :essenceTrackAspectRatio])

    # Proxies to audio essence fields
    t.audio_standard(:proxy=>[:pbcoreInstantiation, :audio_essence, :essenceTrackStandard])
    t.audio_encoding(:proxy=>[:pbcoreInstantiation, :audio_essence, :essenceTrackEncoding])
    t.audio_bit_rate(:proxy=>[:pbcoreInstantiation, :audio_essence, :essenceTrackDataRate])
    t.audio_bit_rate_units(:proxy=>[:pbcoreInstantiation, :audio_essence, :essenceTrackDataRate, :units])
    t.audio_sample_rate(:proxy=>[:pbcoreInstantiation, :audio_essence, :essenceTrackSamplingRate])
    t.audio_sample_rate_units(:proxy=>[:pbcoreInstantiation, :audio_essence, :essenceTrackSamplingRate, :units])
    t.audio_bit_depth(:proxy=>[:pbcoreInstantiation, :audio_essence, :essenceTrackBitDepth])
    t.audio_channels(:proxy=>[:pbcoreInstantiation, :audio_essence, :essenceTrackAnnotation])

  end

  def self.xml_template
    builder = Nokogiri::XML::Builder.new do |xml|

      xml.pbcoreDescriptionDocument("xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
        "xsi:schemaLocation"=>"http://www.pbcore.org/PBCore/PBCoreNamespace.html") {

        # These fields are only added so that this document will be validated.  However, they
        # shouldn't be used for anything else here because they're in the parent Fedora object
        xml.pbcoreIdentifier(:annotation=>"PID", :source=>"Rock and Roll Hall of Fame and Museum")
        xml.pbcoreTitle
        xml.pbcoreDescription

        xml.pbcoreInstantiation {

          xml.instantiationIdentifier(:annotation=>"Filename", :source=>"Rock and Roll Hall of Fame and Museum")
          xml.instantiationDate(:dateType=>"created")
          xml.instantiationDigital(:source=>"EBU file formats")
          xml.instantiationLocation
          xml.instantiationMediaType(:source=>"PBCore instantiationMediaType") {
            xml.text "Moving image"
          }
          xml.instantiationGenerations(:source=>"PBCore instantiationGenerations")
          xml.instantiationFileSize(:unitsOfMeasure=>"")
          xml.instantiationDuration
          xml.instantiationColors(:source=>"PBCore instantiationColors") {
            xml.text "Color"
          }

          xml.instantiationEssenceTrack {
            xml.essenceTrackType {
              xml.text "Video"
            }
            xml.essenceTrackStandard
            xml.essenceTrackEncoding(:source=>"PBCore essenceTrackEncoding")
            xml.essenceTrackDataRate(:unitsOfMeasure=>"")
            xml.essenceTrackFrameRate(:unitsOfMeasure=>"fps")
            xml.essenceTrackBitDepth
            xml.essenceTrackFrameSize(:source=>"PBCore essenceTrackFrameSize")
            xml.essenceTrackAspectRatio(:source=>"PBCore essenceTrackAspectRatio")
          }

          xml.instantiationEssenceTrack {
            xml.essenceTrackType {
              xml.text "Audio"
            }
            xml.essenceTrackStandard
            xml.essenceTrackEncoding(:source=>"PBCore essenceTrackEncoding")
            xml.essenceTrackDataRate(:unitsOfMeasure=>"")
            xml.essenceTrackSamplingRate(:unitsOfMeasure=>"")
            xml.essenceTrackBitDepth
            xml.essenceTrackAnnotation(:annotationType=>"Number of Audio Channels")
          }

          xml.instantiationRights {
            xml.rightsSummary
          }

        }

      }

    end
    return builder.doc
  end

end
end
