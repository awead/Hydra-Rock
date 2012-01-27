module Rockhall
class PbcoreDocument < ActiveFedora::NokogiriDatastream

	include Rockhall::PbcoreMethods

  set_terminology do |t|
    t.root(:path=>"pbcoreDescriptionDocument", :xmlns => '', :namespace_prefix=>nil)

    #
    #  pbcoreDescription fields
    #
    t.pbc_id(:path=>"pbcoreIdentifier", :namespace_prefix=>nil, :namespace_prefix=>nil, :attributes=>{ :source=>"Rock and Roll Hall of Fame and Museum", :annotation=>"PID" })

    t.main_title(:path=>"pbcoreTitle", :namespace_prefix=>nil, :namespace_prefix=>nil, :attributes=>{ :titleType=>"Main" })
    t.alternative_title(:path=>"pbcoreTitle", :namespace_prefix=>nil, :namespace_prefix=>nil, :attributes=>{ :titleType=>"Alternative" })
    t.chapter(:path=>"pbcoreTitle", :namespace_prefix=>nil, :namespace_prefix=>nil, :attributes=>{ :titleType=>"Chapter" })
    t.episode(:path=>"pbcoreTitle", :namespace_prefix=>nil, :attributes=>{ :titleType=>"Episode" })
    t.label(:path=>"pbcoreTitle", :namespace_prefix=>nil, :attributes=>{ :titleType=>"Label" })
    t.segment(:path=>"pbcoreTitle", :namespace_prefix=>nil, :attributes=>{ :titleType=>"Segment" })
    t.subtitle(:path=>"pbcoreTitle", :namespace_prefix=>nil, :attributes=>{ :titleType=>"Subtitle" })
    t.track(:path=>"pbcoreTitle", :namespace_prefix=>nil, :attributes=>{ :titleType=>"Track" })
    t.translation(:path=>"pbcoreTitle", :namespace_prefix=>nil, :attributes=>{ :titleType=>"Translation" })

    # This is only to display all subjects
    t.subjects(:path=>"pbcoreSubject", :namespace_prefix=>nil)

    # Individual subject types defined for entry
    t.lc_subject(:path=>"pbcoreSubject", :namespace_prefix=>nil, :attributes=>{ :source=>"Library of Congress Subject Headings", :ref=>"http://id.loc.gov/authorities/subjects.html" })
    t.lc_name(:path=>"pbcoreSubject", :namespace_prefix=>nil, :attributes=>{ :source=>"Library of Congress Name Authority File", :ref=>"http://id.loc.gov/authorities/names" })
    t.rh_subject(:path=>"pbcoreSubject", :namespace_prefix=>nil, :attributes=>{ :source=>"Rock and Roll Hall of Fame and Museum" })

    t.summary(:path=>"pbcoreDescription", :namespace_prefix=>nil, :attributes=>{ :descriptionType=>"Description",
      :descriptionTypeSource=>"pbcoreDescription/descriptionType",
      :descriptionTypeRef=>"http://pbcore.org/vocabularies/pbcoreDescription/descriptionType#description",
      :annotation=>"Summary"}
    )

    t.parts_list(:path=>"pbcoreDescription", :namespace_prefix=>nil, :attributes=>{ :descriptionType=>"Table of Contents",
      :descriptionTypeSource=>"pbcoreDescription/descriptionType",
      :descriptionTypeRef=>"http://pbcore.org/vocabularies/pbcoreDescription/descriptionType#table-of-contents",
      :annotation=>"Parts List" }
    )

    # This is only to display all genres
    t.genres(:path=>"pbcoreGenre", :namespace_prefix=>nil)

    # Individual genre types defined for entry
    t.getty_genre(:path=>"pbcoreGenre", :namespace_prefix=>nil, :attributes=>{ :source=>"The Getty Research Institute Art and Architecture Thesaurus", :ref=>"http://www.getty.edu/research/tools/vocabularies/aat/index.html" })
    t.lc_genre(:path=>"pbcoreGenre", :namespace_prefix=>nil, :attributes=>{ :source=>"Library of Congress Genre/Form Terms", :ref=>"http://id.loc.gov/authorities/genreForms.html" })
    t.lc_subject_genre(:path=>"pbcoreGenre", :namespace_prefix=>nil, :attributes=>{ :source=>"Library of Congress Subject Headings", :ref=>"http://id.loc.gov/authorities/subjects.html" })


    # Series field
    t.pbcoreRelation(:namespace_prefix=>nil) {
      t.pbcoreRelationIdentifier(:namespace_prefix=>nil, :attributes=>{ :annotation=>"Event Series" })
    }
    t.event_series(:ref=>[:pbcoreRelation, :pbcoreRelationIdentifier])

    # Terms for time and place
    t.pbcore_coverage(:path=>"pbcoreCoverage", :namespace_prefix=>nil) {
      t.coverage(:path=>"coverage", :namespace_prefix=>nil)
    }
    t.spatial(:ref => :pbcore_coverage,
      :path=>'pbcoreCoverage[coverageType="Spatial"]',
      :namespace_prefix=>nil
    )
    t.temporal(:ref => :pbcore_coverage,
      :path=>'pbcoreDescriptionDocument/pbcoreCoverage[coverageType="Temporal"]',
      :namespace_prefix=>nil
    )
    t.event_place(:proxy=>[:spatial, :coverage])
    t.event_date(:proxy=>[:temporal, :coverage])

    # Contributor names and roles
    t.contributor(:path=>"pbcoreContributor", :namespace_prefix=>nil) {
      t.name_(:path=>"contributor", :namespace_prefix=>nil)
      t.role_(:path=>"contributorRole", :namespace_prefix=>nil, :attributes=>{ :source=>"MARC relator terms" })
    }
    t.contributor_name(:proxy=>[:contributor, :name])
    t.contributor_role(:proxy=>[:contributor, :role])

    # Publisher names and roles
    t.publisher(:path=>"pbcorePublisher", :namespace_prefix=>nil) {
      t.name_(:path=>"publisher", :namespace_prefix=>nil)
      t.role_(:path=>"publisherRole", :namespace_prefix=>nil, :attributes=>{ :source=>"PBCore publisherRole" })
    }
    t.publisher_name(:proxy=>[:publisher, :name])
    t.publisher_role(:proxy=>[:publisher, :role])

    t.note(:path=>"pbcoreAnnotation", :namespace_prefix=>nil, :atttributes=>{ :annotationType=>"Notes" })

    #
    # pbcoreInstantiation fields for the physical item
    #
    t.pbcoreInstantiation(:namespace_prefix=>nil) {
      t.instantiationIdentifier(:namespace_prefix=>nil, :attributes=>{ :annotation=>"Barcode", :source=>"Rock and Roll Hall of Fame and Museum" })
      t.instantiationDate(:namespace_prefix=>nil, :attributes=>{ :dateType=>"created" })
      t.instantiationPhysical(:namespace_prefix=>nil, :attributes=>{ :source=>"PBCore instantiationPhysical" })
      t.instantiationStandard(:namespace_prefix=>nil)
      t.instantiationLocation(:namespace_prefix=>nil)
      t.instantiationMediaType(:namespace_prefix=>nil, :attributes=>{ :source=>"PBCore instantiationMediaType" })
      t.instantiationGenerations(:namespace_prefix=>nil, :attributes=>{ :source=>"PBCore instantiationGenerations" })
      t.instantiationColors(:namespace_prefix=>nil)
      t.instantiationLanguage(:namespace_prefix=>nil, :attributes=>{ :source=>"ISO 639.2", :ref=>"http://www.loc.gov/standards/iso639-2/php/code_list.php" })
      t.instantiationRelation(:namespace_prefix=>nil) {
        t.arc_collection(:path=>"instantiationRelationIdentifier", :namespace_prefix=>nil, :attributes=>{ :annotation=>"Archival collection" })
        t.arc_series(:path=>"instantiationRelationIdentifier", :namespace_prefix=>nil, :attributes=>{ :annotation=>"Archival Series" })
        t.col_number(:path=>"instantiationRelationIdentifier", :namespace_prefix=>nil, :attributes=>{ :annotation=>"Collection Number" })
        t.acc_number(:path=>"instantiationRelationIdentifier", :namespace_prefix=>nil, :attributes=>{ :annotation=>"Accession Number" })
      }
      t.instantiationRights(:namespace_prefix=>nil) {
        t.rightsSummary(:namespace_prefix=>nil)
      }
      t.inst_cond_note(:path=>"instantiationAnnotation", :namespace_prefix=>nil, :attributes=>{ :annotationType=>"Condition Notes" })
      t.inst_clean_note(:path=>"instantiationAnnotation", :namespace_prefix=>nil, :attributes=>{ :annotationType=>"Cleaning Notes" })
    }
    # Individual field names:
    t.creation_date(:proxy=>[:pbcoreInstantiation, :instantiationDate])
    t.barcode(:proxy=>[:pbcoreInstantiation, :instantiationIdentifier])
    t.repository(:proxy=>[:pbcoreInstantiation, :instantiationLocation])
    t.format(:proxy=>[:pbcoreInstantiation, :instantiationPhysical])
    t.standard(:proxy=>[:pbcoreInstantiation, :instantiationStandard])
    t.media_type(:proxy=>[:pbcoreInstantiation, :instantiationMediaType])
    t.generation(:proxy=>[:pbcoreInstantiation, :instantiationGenerations])
    t.language(:proxy=>[:pbcoreInstantiation, :instantiationLanguage])
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
    t.pbcorePart(:namespace_prefix=>nil) {
      t.pbcoreTitle(:namespace_prefix=>nil, :attributes=>{ :titleType=>"song", :annotation=>"part title" })
      t.pbcoreIdentifier(:namespace_prefix=>nil, :attributes=>{ :source=>"rock hall", :annotation=>"part number" })
      t.pbcoreDescription(:namespace_prefix=>nil, :attributes=>{ :descriptionType=>"Description",
        :descriptionTypesource=>"pbcoreDescription/descriptionType",
        :ref=>"http://pbcore.org/vocabularies/pbcoreDescription/descriptionType#description" }
      )
      t.pbcoreContributor(:namespace_prefix=>nil) {
        t.contributor(:attributes=>{ :annotation=>"part contributor" })
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

      xml.pbcoreDescriptionDocument("xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
        "xsi:schemaLocation"=>"http://www.pbcore.org/PBCore/PBCoreNamespace.html") {

        xml.pbcoreIdentifier(:source=>"Rock and Roll Hall of Fame and Museum", :annotation=>"PID")
        xml.pbcoreTitle(:titleType=>"Main")
        xml.pbcoreDescription(:descriptionType=>"Description",
          :descriptionTypeSource=>"pbcoreDescription/descriptionType",
          :descriptionTypeRef=>"http://pbcore.org/vocabularies/pbcoreDescription/descriptionType#description",
          :annotation=>"Summary"
        )
        xml.pbcoreDescription(:descriptionType=>"Table of Contents",
          :descriptionTypeSource=>"pbcoreDescription/descriptionType",
          :descriptionTypeRef=>"http://pbcore.org/vocabularies/pbcoreDescription/descriptionType#table-of-contents",
          :annotation=>"Parts List"
        )
        xml.pbcoreRelation {
          xml.pbcoreRelationType(:source=>"PBCore relationType", :ref=>"http://pbcore.org/vocabularies/relationType#is-part-of") {
            xml.text "Is Part Of"
          }
          xml.pbcoreRelationIdentifier(:annotation=>"Event Series")
        }
        xml.pbcoreCoverage {
          xml.coverage(:annotation=>"Event Place")
          xml.coverageType {
            xml.text "Spatial"
          }
        }
        xml.pbcoreCoverage {
          xml.coverage(:annotation=>"Event Date")
          xml.coverageType {
            xml.text "Temporal"
          }
        }
        xml.pbcoreAnnotation(:annotationType=>"Notes")

        #
        # Default physical item
        #
        xml.pbcoreInstantiation {

          # Item details
          xml.instantiationIdentifier(:annotation=>"Barcode", :source=>"Rock and Roll Hall of Fame and Museum")
          xml.instantiationDate(:dateType=>"created")
          xml.instantiationPhysical(:source=>"PBCore instantiationPhysical")
          xml.instantiationStandard
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
          xml.instantiationLanguage(:source=>"ISO 639.2", :ref=>"http://www.loc.gov/standards/iso639-2/php/code_list.php") {
            xml.text "eng"
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
          xml.instantiationRights {
            xml.rightsSummary
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
    solr_doc.merge!(:title_display => self.find_by_terms(:main_title).text)
    solr_doc.merge!(:title_addl_display => self.find_by_terms(:alternative_title).text)
    solr_doc.merge!(:heading_display => self.find_by_terms(:main_title).text)
    solr_doc.merge!(:summary_display => self.find_by_terms(:summary).text)
    solr_doc.merge!(:pub_date_display => self.find_by_terms(:event_date).text)
    solr_doc.merge!(:publisher_display => gather_terms(self.find_by_terms(:publisher_name)))
    solr_doc.merge!(:contributors_display => gather_terms(self.find_by_terms(:contributor_name)))
    solr_doc.merge!(:subject_display => gather_terms(self.find_by_terms(:subjects)))
    solr_doc.merge!(:genre_display => gather_terms(self.find_by_terms(:genres)))

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
    solr_doc.merge!(:material_facet => "Digital")
    solr_doc.merge!(:genre_facet => gather_terms(self.find_by_terms(:genres)))
    solr_doc.merge!(:name_facet => gather_terms(self.find_by_terms(:contributor_name)))
    solr_doc.merge!(:topic_facet => gather_terms(self.find_by_terms(:subjects)))
    solr_doc.merge!(:series_facet => gather_terms(self.find_by_terms(:event_series)))

    unless self.find_by_terms(:archival_collection).nil?
      solr_doc.merge!(:collection_facet => self.find_by_terms(:archival_collection).text)
    end

    # Extract 4-digit year for dates
    date = self.find_by_terms(:event_date).first.text.strip
    unless date.nil? or date.empty?
		  solr_doc.merge!(:pub_date => DateTime.parse(date).strftime("%Y"))
		end

		create = self.find_by_terms(:creation_date).first.text.strip
		unless create.nil? or create.empty?
		  solr_doc.merge!(:create_date_facet => DateTime.parse(create).strftime("%Y"))
		end

		# Create link to item in Hydra
		solr_doc.merge!(:resource_link_display => File.join(RH_CONFIG["hostname"], "catalog", self.pid)) if self.pid

		# For full text, we stuff it into the mods_t field which is already configured for Mods doucments
		solr_doc.merge!(:mods_t => self.ng_xml.text)

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
