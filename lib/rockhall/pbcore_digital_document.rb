module Rockhall
class PbcoreDigitalDocument < ActiveFedora::NokogiriDatastream

	include Rockhall::PbcoreMethods
  include Rockhall::IndexMethods


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


    # Pbcore relation fields
    t.pbcoreRelation(:namespace_prefix=>nil) {
      t.series(:path=>"pbcoreRelationIdentifier", :namespace_prefix=>nil, :attributes=>{ :annotation=>"Event Series" })
      t.arch_coll(:path=>"pbcoreRelationIdentifier", :namespace_prefix=>nil, :attributes=>{ :annotation=>"Archival Collection" })
      t.arch_ser(:path=>"pbcoreRelationIdentifier", :namespace_prefix=>nil, :attributes=>{ :annotation=>"Archival Series" })
      t.coll_num(:path=>"pbcoreRelationIdentifier", :namespace_prefix=>nil, :attributes=>{ :annotation=>"Collection Number" })
      t.acc_num(:path=>"pbcoreRelationIdentifier", :namespace_prefix=>nil, :attributes=>{ :annotation=>"Accession Number" })
    }
    t.event_series(:ref=>[:pbcoreRelation, :series])
    t.archival_collection(:ref=>[:pbcoreRelation, :arch_coll])
    t.archival_series(:ref=>[:pbcoreRelation, :arch_ser])
    t.collection_number(:ref=>[:pbcoreRelation, :coll_num])
    t.accession_number(:ref=>[:pbcoreRelation, :acc_num])

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

    t.usage(:path=>"pbcoreRightsSummary", :namespace_prefix=>nil)

    t.note(:path=>"pbcoreAnnotation", :namespace_prefix=>nil, :atttributes=>{ :annotationType=>"Notes" })

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
        xml.pbcoreRelation {
          xml.pbcoreRelationType(:source=>"PBCore relationType", :ref=>"http://pbcore.org/vocabularies/relationType#is-part-of") {
            xml.text "Is Part Of"
          }
          xml.pbcoreRelationIdentifier(:annotation=>"Archival Collection")
        }
        xml.pbcoreRelation {
          xml.pbcoreRelationType(:source=>"PBCore relationType", :ref=>"http://pbcore.org/vocabularies/relationType#is-part-of") {
            xml.text "Is Part Of"
          }
          xml.pbcoreRelationIdentifier(:annotation=>"Archival Series")
        }
        xml.pbcoreRelation {
          xml.pbcoreRelationType(:source=>"PBCore relationType", :ref=>"http://pbcore.org/vocabularies/relationType#is-part-of") {
            xml.text "Is Part Of"
          }
          xml.pbcoreRelationIdentifier(:annotation=>"Collection Number")
        }
        xml.pbcoreRelation {
          xml.pbcoreRelationType(:source=>"PBCore relationType", :ref=>"http://pbcore.org/vocabularies/relationType#is-part-of") {
            xml.text "Is Part Of"
          }
          xml.pbcoreRelationIdentifier(:annotation=>"Accession Number")
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
        xml.pbcoreRightsSummary
        xml.pbcoreAnnotation(:annotationType=>"Notes")

      }

    end
    return builder.doc
  end


  def to_solr(solr_doc=Solr::Document.new)
    super(solr_doc)

    solr_doc.merge!(:format => "Video")
    solr_doc.merge!(:title_t => self.find_by_terms(:main_title).text)

    # Specific fields for Blacklight export

    # Title fields
    solr_doc.merge!(:title_display => self.find_by_terms(:main_title).text)
    ["alternative_title", "chapter", "episode", "label", "segment", "subtitle", "track", "translation"].each do |addl_title|
      solr_doc.merge!(:title_addl_display => self.find_by_terms(addl_title.to_sym).text)
    end
    solr_doc.merge!(:heading_display => self.find_by_terms(:main_title).text)

    # Individual fields
    solr_doc.merge!(:summary_display => self.find_by_terms(:summary).text)
    solr_doc.merge!(:pub_date_display => self.find_by_terms(:event_date).text)
    solr_doc.merge!(:publisher_display => gather_terms(self.find_by_terms(:publisher_name)))
    solr_doc.merge!(:contributors_display => format_contributors_display)
    solr_doc.merge!(:subject_display => gather_terms(self.find_by_terms(:subjects)))
    solr_doc.merge!(:genre_display => gather_terms(self.find_by_terms(:genres)))
    solr_doc.merge!(:series_display => gather_terms(self.find_by_terms(:event_series)))

    solr_doc.merge!(:recinfo_display => gather_terms(self.find_by_terms(:event_place)))
    solr_doc.merge!(:recinfo_display => gather_terms(self.find_by_terms(:event_date)))
    solr_doc.merge!(:contents_display => gather_terms(self.find_by_terms(:parts_list)))
    solr_doc.merge!(:notes_display => gather_terms(self.find_by_terms(:note)))



    # Blacklight facets - these are the same facet fields used in our Blacklight app
    # for consistency and so they'll show up when we export records from Hydra into BL:
    solr_doc.merge!(:material_facet => "Digital")
    solr_doc.merge!(:genre_facet => gather_terms(self.find_by_terms(:genres)))
    solr_doc.merge!(:name_facet => gather_terms(self.find_by_terms(:contributor_name)))
    solr_doc.merge!(:subject_topic_facet => gather_terms(self.find_by_terms(:subjects)))
    solr_doc.merge!(:series_facet => gather_terms(self.find_by_terms(:event_series)))

    # These fields are not in the parent...
    #solr_doc.merge!(:format_facet => gather_terms(self.find_by_terms(:format)))
    #solr_doc.merge!(:collection_facet => gather_terms(self.find_by_terms(:archival_collection)))
    #solr_doc.merge!(:collection_display => gather_terms(self.find_by_terms(:archival_collection)))
    #solr_doc.merge!(:physical_dtl_display => gather_terms(self.find_by_terms(:format)))
    #solr_doc.merge!(:access_display => gather_terms(self.find_by_terms(:usage)))

    # TODO: map PBcore's three-letter language codes to full language names
    # Right now, everything's English.
    # language field is not in the parent... yet?
#     if self.find_by_terms(:language).text.match("eng")
#       solr_doc.merge!(:language_facet => "English")
#       solr_doc.merge!(:language_display => "English")
#     else
#       solr_doc.merge!(:language_facet => "Unknown")
#       solr_doc.merge!(:language_display => "Unknown")
#     end

    # Extract 4-digit year for creation date facet in Hydra and pub_date facet in Blacklight
    # not in parent
# 		create = self.find_by_terms(:creation_date).text.strip
# 		unless create.nil? or create.empty?
# 		  solr_doc.merge!(:create_date_facet => DateTime.parse(create).strftime("%Y"))
# 		  solr_doc.merge!(:pub_date => DateTime.parse(create).strftime("%Y"))
# 		end

		# For full text, we stuff it into the mods_t field which is already configured for Mods doucments
		solr_doc.merge!(:mods_t => self.ng_xml.text)

    return solr_doc
  end
  

end
end
