module Rockhall
class PbcoreDocument < ActiveFedora::NokogiriDatastream

	include Rockhall::PbcoreMethods

  set_terminology do |t|
    t.root(:path=>"pbcoreDescriptionDocument", :xmlns=>"http://www.pbcore.org/PBCore/PBCoreNamespace.html", :schema=>"http://www.pbcore.org/PBCore/PBCoreNamespace.html")

    #
    # Descriptive elements
    #

    t.pbc_id(:path=>"pbcoreIdentifier", :attributes=>{ :source=>"rockhall", :annotation=>"Fedora ID" })
    t.media_type(:path=>"instantiationMediaType")

    t.full_title(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Full", :annotation=>"title as seen on-screen" })
    t.sub_title(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Subtitle" } )
    t.alt_title(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Alternatitve", :annotation=>"Other Title" } )
    t.episode(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Episode" } )

    t.series(:path=>"pbcoreRelation") {
      t.type_(:path=>"pbcoreRelationType", :attributes=>{ :source=>"PBCore relationType" })
      t.name_(:path=>"pbcoreRelationIdentifier")
    }

    t.contributor(:path=>"pbcoreContributor") {
      t.name_(:path=>"contributor")
      t.role(:path=>"contributorRole", :attributes=>{ :source=>"MARC List for Relators" }) {
      	t.ref(:path=>{:attribute=>"ref"})
      }
    }

    t.language(:path=>"instantiationLanguage", :attributes=>{ :source=>"ISO 639.2" }) {
      t.ref(:path=>{:attribute=>"ref"})
    }

    t.caption(:path=>"instantiationAlternativeModes")

    t.summary(:path=>"pbcoreDescription", :attributes=>{ :descriptionType=>"Summary",
      :descriptionTypeSource=>"pbcoreDescription/descriptionType",
      :ref=>"http://pbcore.org/vocabularies/pbcoreDescription/descriptionType#summary" }
    )

    # The annotation attribute defines the coverage type
    t.coverage(:path=>"pbcoreCoverage") {
      t.event(:path=>"coverage", :attributes=>{ :annotation=>"Event Location" })
      t.date(:path=>"coverage", :attributes=>{ :annotation=>"Event Date" })
    }

    t.contents(:path=>"pbcoreDescription", :attributes=>{ :descriptionType=>"Table of Contents",
      :descriptionTypeSource=>"pbcoreDescription/descriptionType",
      :ref=>"http://pbcore.org/vocabularies/pbcoreDescription/descriptionType#table-of-contents" }
    )

    t.note(:path=>"pbcoreAnnotation", :atttributes=>{ :annotationType=>"note" })

    t.subject(:path=>"pbcoreSubject")
    t.entity(:ref=>[:subject], :attributes=>{ :subjectType=>"entity", :source=>"Library of Congress Name Authorities" })
    t.era(:ref=>[:subject], :attributes=>{ :subjectType=>"era", :source=>"Library of Congress Subject Headings" })
    t.place(:ref=>[:subject], :attributes=>{ :subjectType=>"place", :source=>"Library of Congress Subject Headings" })
    t.event(:ref=>[:subject], :attributes=>{ :subjectType=>"event", :source=>"Library of Congress Subject Headings" })
    t.topic(:ref=>[:subject], :attributes=>{ :subjectType=>"topic", :source=>"Library of Congress Subject Headings" }) {
    	t.ref(:path=>{:attribute=>"ref"})
    }

    t.genre(:path=>"pbcoreGenre", :attributes=>{ :source=>"Library of Congress Subject Headings" }) {
      t.ref(:path=>{:attribute=>"ref"})
    }

    t.publisher(:path=>"pbcorePublisher") {
      t.name_(:path=>"publisher")
      t.role(:path=>"publisherRole", :attributes=>{ :source=>"PBcore publisherRole" }) {
      	t.ref(:path=>{:attribute=>"ref"})
      }
    }

    #
    # Physical instantiation
    #
    t.item(:path=>"pbcoreInstantiation") {

      # Item details
      t.type_(:path=>"instantiationGenerations", :attributes=>{ :source=>"PBCore instantiationGenerations" }) {
        t.ref(:path=>{:attribute=>"ref"})
      }
      t.carrier(:path=>"instantiationPhysical")
      t.standard(:path=>"instantiationStandard")
      t.barcode(:path=>"instantiationIdentifier", :attributes=>{ :source=>"rockhall", :annotation=>"barcode" })

      # Collection information
      t.relation(:path=>"instantiationRelation") {
        t.type_(:path=>"instantiationRelationType", :attributes=>{ :source=>"PBCore relationType" })
        t.name_(:path=>"instantiationRelationIdentifier") {
        	t.source(:path=>{:attribute=>"source"})
        	t.annotation(:path=>{:attribute=>"annotation"})
        }
        t.collection_name(:ref=>[:item, :relation, :name], :attributes=>{ :source=>"rockhall", :annotation=>"collection name" })
        t.collection_number(:ref=>[:item, :relation, :name], :attributes=>{ :source=>"rockhall", :annotation=>"collection number" })
        t.accession_number(:ref=>[:item, :relation, :name], :attributes=>{ :source=>"rockhall", :annotation=>"accession number" })
      }
      t.location(:path=>"instantiationLocation")

      # Notes
      t.note(:path=>"instantiationAnnotation", :attributes=>{ :annotationType=>"note" })
    }

  end


  def self.xml_template
    builder = Nokogiri::XML::Builder.new do |xml|

      xml.pbcoreDescriptionDocument(:version=>"2.0", "xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
        "xmlns"=>"http://www.pbcore.org/PBCore/PBCoreNamespace.html",
        "xsi:schemaLocation"=>"http://www.pbcore.org/PBCore/PBCoreNamespace.html") {

        xml.instantiationMediaType(:source=>"PBCore instantiationMediaType", :ref=>"http://pbcore.org/vocabularies/instantiationMediaType#moving-image") {
          xml.text "Moving image"
        }

        xml.pbcoreIdentifier(:source=>"rockhall", :annotation=>"Fedora ID")

        xml.pbcoreTitle(:titleType=>"Full", :annotation=>"title as seen on-screen")

        # Default language is English
        xml.instantiationLanguage(:source=>"ISO 639.2", :ref=>"http://id.loc.gov/vocabulary/iso639-2/eng.html")

        xml.pbcoreDescription(:descriptionType=>"Summary",
          :descriptionTypeSource=>"pbcoreDescription/descriptionType",
          :ref=>"http://pbcore.org/vocabularies/pbcoreDescription/descriptionType#summary"
        )

        xml.pbcoreDescription(:descriptionType=>"Table of Contents",
          :descriptionTypeSource=>"pbcoreDescription/descriptionType",
          :ref=>"http://pbcore.org/vocabularies/pbcoreDescription/descriptionType#table-of-contents"
        )

        xml.pbcoreCoverage {
          xml.coverage(:annotation=>"Event Location")
          xml.coverageType(:source=>"PBCore coverageType", :ref=>"http://pbcore.org/vocabularies/coverageType#spatial") {
            xml.text "Spatial"
          }
        }

        xml.pbcoreCoverage {
          xml.coverage(:annotation=>"Event Date")
          xml.coverageType(:source=>"PBCore coverageType", :ref=>"http://pbcore.org/vocabularies/coverageType#temporal") {
            xml.text "Temporal"
          }
        }

        xml.pbcoreAnnotation(:annotationType=>"note")

        #
        # Default physical item
        #
        xml.pbcoreInstantiation {

          # Item details
          xml.instantiationGenerations(:source=>"PBCore instantiationGenerations", :ref=>"http://pbcore.org/vocabularies/instantiationGenerations#original") {
            xml.text "Original"
          }
          xml.instantiationPhysical(:source=>"PBCore instantiationPhysical")
          xml.instantiationStandard(:source=>"PBCore instantiationStandard")
          xml.instantiationIdentifier(:source=>"rockhall", :annotation=>"barcode")

          # Collection name
          xml.instantiationRelation {
            xml.instantiationRelationType(:source=>"PBCore relationType", :ref=>"http://pbcore.org/vocabularies/relationType#is-part-of") {
              xml.text "Is Part Of"
            }
            xml.instantiationRelationIdentifier(:source=>"rockhall", :annotation=>"collection name")
          }

          # Collection number
          xml.instantiationRelation {
            xml.instantiationRelationType(:source=>"PBCore relationType", :ref=>"http://pbcore.org/vocabularies/relationType#is-part-of") {
              xml.text "Is Part Of"
            }
            xml.instantiationRelationIdentifier(:source=>"rockhall", :annotation=>"collection number")
          }

          # Accession number
          xml.instantiationRelation {
            xml.instantiationRelationType(:source=>"PBCore relationType", :ref=>"http://pbcore.org/vocabularies/relationType#is-part-of") {
              xml.text "Is Part Of"
            }
            xml.instantiationRelationIdentifier(:source=>"rockhall", :annotation=>"accession number")
          }

          # Location
          xml.instantiationLocation {
            xml.text "Rock and Roll Hall of Fame and Museum,\n2809 Woodland Ave.,\nCleveland, OH, 44115\n216-515-1956\nlibrary@rockhall.org"
          }

          # Notes
          xml.instantiationAnnotation(:annotationType=>"note") {
            xml.text "Copies from original can be made upon request.\nSpeak to an archivist for fees and specifications."
          }

        }

      }

    end
    return builder.doc
  end

  def to_solr(solr_doc=Solr::Document.new)
  super(solr_doc)

    solr_doc.merge!(:format => "Video")
    solr_doc.merge!(:title_t => self.find_by_terms(:full_title).text)

    # Specific fields for Blacklight export
    solr_doc.merge!(:title_display => self.find_by_terms(:full_title).text)
    solr_doc.merge!(:heading_display => self.find_by_terms(:full_title).text)

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

    genres = Array.new
    self.find_by_terms(:genre).each { |genre| genres << genre.text }
    solr_doc.merge!(:genre_facet => genres)

    events = Array.new
    self.find_by_terms(:series).each { |series| events << series.text }
    self.find_by_terms(:event).each { |event| events << event.text }
    solr_doc.merge!(:series_facet => events)

    names = Array.new
    self.find_by_terms(:contributor, :name).each { |name| names << name.text }
    solr_doc.merge!(:name_facet => names)

    topics = Array.new
    self.find_by_terms(:topic).each { |topic| topics << topic.text }
    solr_doc.merge!(:topic_facet => topics)

		solr_doc.merge!(:collection_facet => self.find_by_terms(:item, :relation, :collection_name).first.text.strip)

		solr_doc.merge!(:language_facet => self.find_by_terms(:language).first.text.strip)

    # Extract 4-digit year
    date = self.find_by_terms(:coverage, :date).first.text.strip
    unless date.nil? or date.empty?
		  solr_doc.merge!(:pub_date => DateTime.parse(date).strftime("%Y"))
		end

		# For full text, we stuff it into the mods_t field which is already configured for Mods doucments
		solr_doc.merge!(:mods_t => self.ng_xml.text)

    return solr_doc
  end

end
end
