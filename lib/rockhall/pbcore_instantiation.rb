module Rockhall
class PbcoreInstantiation < ActiveFedora::NokogiriDatastream

  include Rockhall::PbcoreMethods

  # Note: this is not a complete PBcore document, just an instantiation node
  set_terminology do |t|
    t.root(:path=>"pbcoreDescriptionDocument", :xmlns => '', :namespace_prefix=>nil)

    t.pbcoreInstantiation(:namespace_prefix=>nil) {

      t.instantiationIdentifier(:namespace_prefix=>nil)
      t.instantiationFileSize(:namespace_prefix=>nil) {
        t.units(:path=>{:attribute=>"unitsOfMeasure"}, :namespace_prefix=>nil)
      }
      t.instantiationDate(:namespace_prefix=>nil, :attributes=>{ :dateType=>"creation date" })
      t.instantiationDigital(:namespace_prefix=>nil, :attributes=>{ :source=>"EBU file formats" })
      t.instantiationGenerations(:namespace_prefix=>nil, :attributes=>{ :source=>"PBCore instantiationGenerations" })
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
        t.essenceTrackFrameSize(:namespace_prefix=>nil, :attributes=>{ :source=>"PBcore essenceTrackFrameSize" })
        t.essenceTrackBitDepth(:namespace_prefix=>nil)
        t.essenceTrackAspectRatio(:namespace_prefix=>nil, :attributes=>{ :source=>"PBcore essenceTrackAspectRatio" })
        t.essenceTrackSamplingRate(:namespace_prefix=>nil) {
          t.units(:path=>{:attribute=>"unitsOfMeasure"}, :namespace_prefix=>nil)
        }
        t.essenceTrackAnnotation( :namespace_prefix=>nil, :attributes=>{ :annotationType=>"number of audio channels" })
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
      t.inst_chksum_type(:path=>"instantiationAnnotation", :namespace_prefix=>nil, :attributes=>{ :annotationType=>"checksum type" })
      t.inst_chksum_value(:path=>"instantiationAnnotation", :namespace_prefix=>nil, :attributes=>{ :annotationType=>"checksum value" })
      t.inst_device(:path=>"instantiationAnnotation", :namespace_prefix=>nil, :attributes=>{ :annotationType=>"playback device" })
      t.inst_capture_soft(:path=>"instantiationAnnotation", :namespace_prefix=>nil, :attributes=>{ :annotationType=>"capture software" })
      t.inst_trans_soft(:path=>"instantiationAnnotation", :namespace_prefix=>nil, :attributes=>{ :annotationType=>"transcoding software" })
      t.inst_operator(:path=>"instantiationAnnotation", :namespace_prefix=>nil, :attributes=>{ :annotationType=>"operator" })
      t.inst_trans_note(:path=>"instantiationAnnotation", :namespace_prefix=>nil, :attributes=>{ :annotationType=>"transfer notes" })
      t.inst_vendor(:path=>"instantiationAnnotation", :namespace_prefix=>nil, :attributes=>{ :annotationType=>"vendor name" })
      t.inst_cond_note(:path=>"instantiationAnnotation", :namespace_prefix=>nil, :attributes=>{ :annotationType=>"condition notes" })
      t.inst_clean_note(:path=>"instantiationAnnotation", :namespace_prefix=>nil, :attributes=>{ :annotationType=>"cleaning notes" })
      t.inst_note(:path=>"instantiationAnnotation", :namespace_prefix=>nil, :attributes=>{ :annotationType=>"note" })
      t.inst_color_space(:path=>"instantiationAnnotation", :namespace_prefix=>nil, :attributes=>{ :annotationType=>"color space" })
      t.inst_chroma(:path=>"instantiationAnnotation", :namespace_prefix=>nil, :attributes=>{ :annotationType=>"chroma" })

    }

    #
    # Here are the actual references to the fields
    #

    t.name(:proxy=>[:pbcoreInstantiation, :instantiationIdentifier])
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

      xml.pbcoreDescriptionDocument(:version=>"2.0", "xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
        "xsi:schemaLocation"=>"http://www.pbcore.org/PBCore/PBCoreNamespace.html") {

        xml.pbcoreInstantiation {

          xml.instantiationIdentifier
          xml.instantiationFileSize(:unitsOfMeasure=>"")
          xml.instantiationDate(:dateType=>"creation date")
          xml.instantiationDigital(:source=>"EBU file formats")
          xml.instantiationGenerations(:source=>"PBCore instantiationGenerations")
          xml.instantiationMediaType(:source=>"PBCore instantiationMediaType") {
            xml.text "Moving image"
          }
          xml.instantiationColors(:source=>"PBCore instantiationColors") {
            xml.text "Color"
          }
          xml.instantiationDuration

          xml.instantiationRights {
            xml.rightsSummary
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
            xml.essenceTrackAnnotation(:annotationType=>"number of audio channels")
          }

        }

      }

    end
    return builder.doc
  end

end
end
