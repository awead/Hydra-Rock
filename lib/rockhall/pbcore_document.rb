module Rockhall
class PbcoreDocument < ActiveFedora::NokogiriDatastream

	include Rockhall::PbcoreMethods

  set_terminology do |t|
    t.root(:path=>"pbcoreDescriptionDocument", #:xmlns => '', :namespace_prefix => nil)
      :xmlns=>"http://www.pbcore.org/PBCore/PBCoreNamespace.html",
      :schema=>"http://www.pbcore.org/PBCore/PBCoreNamespace.html"
    )

    #
    #  pbcoreDescription fields
    #
    t.pbc_id(:path=>"pbcoreIdentifier", :attributes=>{ :source=>"rock hall", :annotation=>"Fedora ID" })

    t.main_title(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"main" })
    t.alternative_title(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"alternative" })
    t.chapter(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"chapter" })
    t.episode(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"episode" })
    t.label(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"label" })
    t.segment(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"segment" })
    t.subtitle(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"subtitle" })
    t.track(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"track" })
    t.translation(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"translation" })

    t.description(:path=>"descriptionType", :attributes=>{ :descriptionTypesource=>"pbcoreDescription/descriptionType",
      :ref=>"http://pbcore.org/vocabularies/pbcoreDescription/descriptionType#description",
      :annotation=>"main"}
    )

    t.contents(:path=>"pbcoreDescription", :attributes=>{ :descriptionType=>"Table of Contents",
      :descriptionTypeSource=>"pbcoreDescription/descriptionType",
      :ref=>"http://pbcore.org/vocabularies/pbcoreDescription/descriptionType#table-of-contents" }
    )

    t.subject(:path=>"pbcoreSubject")

    t.genre(:path=>"pbcoreGenre")

    # Series field
    t.pbcoreRelation {
      t.pbcoreRelationIdentifier(:attributes=>{ :annotation=>"Event Series" })
    }
    t.series(:ref=>[:pbcoreRelation, :pbcoreRelationIdentifier])

    # Terms for time and place
    t.pbcore_coverage(:path=>"pbcoreCoverage") {
      t.coverage(:path=>"coverage")
    }
    t.spatial(:ref => :pbcore_coverage,
      :path=>'pbcoreCoverage[coverageType="Spatial"]',
      :namespace_prefix=>nil
    )
    t.temporal(:ref => :pbcore_coverage,
      :path=>'pbcoreDescriptionDocument/pbcoreCoverage[coverageType="Temporal"]'
    )
    t.event_place(:proxy=>[:spatial, :coverage])
    t.event_time(:proxy=>[:temporal, :coverage])

    # Contributor names and roles
    t.pbcoreContributor {
      t.contributor
      t.contributorRole(:attributes=>{ :source=>"MARC relator terms" })
    }
    t.contributor_name(:ref=>[:pbcoreContributor, :contributor])
    t.contributor_role(:ref=>[:pbcoreContributor, :contributorRole])

    # Publisher names and roles
    t.pbcorePublisher {
      t.publisher
      t.publisherRole(:attributes=>{ :source=>"PBcore publisherRole" })
    }
    t.publisher_name(:ref=>[:pbcorePublisher, :publisher])
    t.publisher_role(:ref=>[:pbcorePublisher, :publisherRole])

    t.note(:path=>"pbcoreAnnotation", :atttributes=>{ :annotationType=>"Notes" })


    #
    # pbcoreInstantiation fields for the physical item
    #
    t.pbcoreInstantiation {
      t.instantiationDate(:attributes=>{ :dateType=>"creation date" })
      t.instantiationIdentifier
      t.instantiationLocation
      t.instantiationPhysical(:attributes=>{ :source=>"PBCore instantiationPhysical" })
      t.instantiationStandard
      t.instantiationMediaType(:attributes=>{ :source=>"PBCore instantiationMediaType" })
      t.instantiationGenerations(:attributes=>{ :source=>"PBCore instantiationGenerations" })
      t.instantiationColors
      t.instantiationRelation {
        t.arc_collection(:path=>"instantiationRelationIdentifier", :attributes=>{ :annotation=>"Archival Collection" })
        t.arc_series(:path=>"instantiationRelationIdentifier", :attributes=>{ :annotation=>"Archival Series" })
        t.col_number(:path=>"instantiationRelationIdentifier", :attributes=>{ :annotation=>"Collection Number" })
        t.acc_number(:path=>"instantiationRelationIdentifier", :attributes=>{ :annotation=>"Accession Number" })
      }
      t.instantiationRights {
        t.rightsSummary
      }
      t.inst_cond_note(:path=>"instantiationAnnotation", :attributes=>{ :annotationType=>"Condition Notes" })
      t.inst_clean_note(:path=>"instantiationAnnotation", :attributes=>{ :annotationType=>"Cleaning Notes" })
    }
    # Individual field names:
    t.creation_date(:proxy=>[:pbcoreInstantiation, :instantiationDate])
    t.barcode(:proxy=>[:pbcoreInstantiation, :instantiationIdentifier])
    t.repository(:proxy=>[:pbcoreInstantiation, :instantiationLocation])
    t.format(:proxy=>[:pbcoreInstantiation, :instantiationPhysical])
    t.standard(:proxy=>[:pbcoreInstantiation, :instantiationStandard])
    t.media_type(:proxy=>[:pbcoreInstantiation, :instantiationMediaType])
    t.generation(:proxy=>[:pbcoreInstantiation, :instantiationGenerations])
    t.colors(:proxy=>[:pbcoreInstantiation, :instantiationColors])
    t.archival_collection(:proxy=>[:pbcoreInstantiation, :instantiationRelation, :arc_collection])
    t.archival_series(:proxy=>[:pbcoreInstantiation, :instantiationRelation, :arc_series])
    t.collection_number(:proxy=>[:pbcoreInstantiation, :instantiationRelation, :col_number])
    t.accession_number(:proxy=>[:pbcoreInstantiation, :instantiationRelation, :acc_number])
    t.usage(:proxy=>[:pbcoreInstantiation, :instantiationRights, :rightsSummary])
    t.condition_note(:proxy=>[:pbcoreInstantiation, :inst_cond_note])
    t.cleaning_note(:proxy=>[:pbcoreInstantiation, :inst_clean_note])

    #
    # pbcorePart fields
    #
    t.pbcorePart {
      t.pbcoreTitle(:attributes=>{ :titleType=>"song", :annotation=>"Part Title" })
      t.pbcoreIdentifier(:attributes=>{ :source=>"rock hall", :annotation=>"Part Number" })
      t.pbcoreDescription(:attributes=>{ :descriptionType=>"Description",
        :descriptionTypesource=>"pbcoreDescription/descriptionType",
        :ref=>"http://pbcore.org/vocabularies/pbcoreDescription/descriptionType#description" }
      )
      t.pbcoreContributor {
        t.contributor(:attributes=>{ :annotation=>"Part Contributor" })
        t.contributorRole(:attributes=>{ :source=>"MARC relator terms" })
      }
    }
    t.part_title(:ref=>[:pbcorePart, :pbcoreTitle])
    t.part_number(:ref=>[:pbcorePart, :pbcoreIdentifier])
    t.part_description(:ref=>[:pbcorePart, :pbcoreDescription])
    t.part_contributor(:ref=>[:pbcorePart, :pbcoreContributor, :contributor])
    t.part_role(:ref=>[:pbcorePart, :pbcoreContributor, :contributorRole])

  end


  def self.xml_template
    builder = Nokogiri::XML::Builder.new do |xml|

      xml.pbcoreDescriptionDocument(:version=>"2.0", "xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
        "xmlns"=>"http://www.pbcore.org/PBCore/PBCoreNamespace.html",
        "xsi:schemaLocation"=>"http://www.pbcore.org/PBCore/PBCoreNamespace.html") {

        xml.pbcoreIdentifier(:source=>"rock hall", :annotation=>"Fedora ID")
        xml.pbcoreTitle(:titleType=>"main")
        xml.pbcoreDescription(:descriptionType=>"Description",
          :descriptionTypesource=>"pbcoreDescription/descriptionType",
          :ref=>"http://pbcore.org/vocabularies/pbcoreDescription/descriptionType#description",
          :annotation=>"main"
        )
        xml.pbcoreDescription(:descriptionType=>"table of contents",
          :source=>"pbcoreDescription/descriptionType",
          :ref=>"http://pbcore.org/vocabularies/pbcoreDescription/descriptionType#table-of-contents",
          :annotation=>"Parts List"
        )
        xml.pbcoreRelation {
          xml.pbcoreRelationType(:source=>"PBCore relationType", :ref=>"http://pbcore.org/vocabularies/relationType#is-part-of") {
            xml.text "Is Part Of"
          }
          xml.pbcoreRelationIdentifier(:annotation=>"Event Series")
        }
        xml.pbcoreCoverage {
          xml.coverage
          xml.coverageType(:annotation=>"Event Place") {
            xml.text "Spatial"
          }
        }
        xml.pbcoreCoverage {
          xml.coverage
          xml.coverageType(:annotation=>"Event Date") {
            xml.text "Temporal"
          }
        }
        xml.pbcoreAnnotation(:annotationType=>"Notes")

        #
        # Default physical item
        #
        xml.pbcoreInstantiation {

          # Item details
          xml.instantiationDate(:dateType=>"creation date")
          xml.instantiationIdentifier
          xml.instantiationLocation {
            xml.text "Rock and Roll Hall of Fame and Museum,\n2809 Woodland Ave.,\nCleveland, OH, 44115\n216-515-1956\nlibrary@rockhall.org"
          }
          xml.instantiationMediaType(:source=>"PBCore instantiationMediaType") {
            xml.text "Moving image"
          }
          xml.instantiationGenerations(:source=>"PBCore instantiationGenerations") {
            xml.text "Original"
          }
          xml.instantiationColors {
            xml.text "Color"
          }
          xml.instantiationRelation {
            xml.instantiationRelationType(:source=>"PBCore relationType", :ref=>"http://pbcore.org/vocabularies/relationType#is-part-of") {
              xml.text "Is Part Of"
            }
            xml.instantiationRelationIdentifier(:annotation=>"Archival Collection")
          }
          xml.instantiationRelation {
            xml.instantiationRelationType(:source=>"PBCore relationType", :ref=>"http://pbcore.org/vocabularies/relationType#is-part-of") {
              xml.text "Is Part Of"
            }
            xml.instantiationRelationIdentifier(:annotation=>"Archival Series")
          }
          xml.instantiationRelation {
            xml.instantiationRelationType(:source=>"PBCore relationType", :ref=>"http://pbcore.org/vocabularies/relationType#is-part-of") {
              xml.text "Is Part Of"
            }
            xml.instantiationRelationIdentifier(:annotation=>"Collection Number")
          }
          xml.instantiationRelation {
            xml.instantiationRelationType(:source=>"PBCore relationType", :ref=>"http://pbcore.org/vocabularies/relationType#is-part-of") {
              xml.text "Is Part Of"
            }
            xml.instantiationRelationIdentifier(:annotation=>"Accession Number")
          }

        }

      }

    end
    return builder.doc
  end


  def to_solr(solr_doc=Solr::Document.new)
    super(solr_doc)

    solr_doc.merge!(:format => "Video")
    solr_doc.merge!(:title_t => self.find_by_terms(:main_title).text)

    # Specific fields for Blacklight export
#     solr_doc.merge!(:title_display => self.find_by_terms(:full_title).text)
#     solr_doc.merge!(:title_addl_display => self.find_by_terms(:alt_title).text)
#     solr_doc.merge!(:heading_display => self.find_by_terms(:full_title).text)
#     solr_doc.merge!(:language_display => self.find_by_terms(:language).text)
#     solr_doc.merge!(:summary_display => self.find_by_terms(:summary).text)
#     solr_doc.merge!(:pub_date_display => self.find_by_terms(:coverage, :date).text)
#     solr_doc.merge!(:publisher_display => gather_terms(self.find_by_terms(:publisher, :name)))
#     solr_doc.merge!(:contributors_display => gather_terms(self.find_by_terms(:contributor, :name)))
#     solr_doc.merge!(:subject_display => gather_terms(self.find_by_terms(:subject)))
#     solr_doc.merge!(:genre_display => gather_terms(self.find_by_terms(:genre)))
#     solr_doc.merge!(:series_display => gather_terms(self.find_by_terms(:series, :name)))
#     solr_doc.merge!(:contents_display => gather_terms(self.find_by_terms(:contents)))



    # Blacklight facets - these are the same facet fields used in our Blacklight app
    # for consistency and so they'll show up when we export records from Hydra into BL:
    #   format
    #   collection_facet
    #   material_facet
    #   pub_date
    #   topic_facet
    #   name_facet
    #   series_facet
    #   language_facet
    #   lc_1letter_facet
    #   genre_facet
    #solr_doc.merge!(:material_facet => "Digital")

    #solr_doc.merge!(:genre_facet => gather_terms(self.find_by_terms(:genre)))
    #solr_doc.merge!(:name_facet => gather_terms(self.find_by_terms(:contributor, :name)))
    #solr_doc.merge!(:topic_facet => gather_terms(self.find_by_terms(:topic)))

    # Series and events are consolidated into a single field
    #events = Array.new
    #self.find_by_terms(:series, :name).each { |series| events << series.text }
    #self.find_by_terms(:event).each { |event| events << event.text }
    #solr_doc.merge!(:series_facet => events)

		#solr_doc.merge!(:collection_facet => self.find_by_terms(:item, :relation, :collection_name).first.text.strip)

		#solr_doc.merge!(:language_facet => self.find_by_terms(:language).first.text.strip)

    # Extract 4-digit year
    #date = self.find_by_terms(:coverage, :date).first.text.strip
    #unless date.nil? or date.empty?
		#  solr_doc.merge!(:pub_date => DateTime.parse(date).strftime("%Y"))
		#end

		# Create link to item in Hydra
		#solr_doc.merge!(:resource_link_display => File.join(RH_CONFIG["hostname"], "catalog", self.pid)) if self.pid

		# For full text, we stuff it into the mods_t field which is already configured for Mods doucments
		#solr_doc.merge!(:mods_t => self.ng_xml.text)

    return solr_doc
  end

  private

  def gather_terms(terms)
    results = Array.new
    terms.each { |r| results << r.text }
    return results
  end

end
end
