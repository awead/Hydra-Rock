module Rockhall
class ModsImage < ActiveFedora::NokogiriDatastream

  include Hydra::CommonModsIndexMethods
  include Rockhall::ModsContributors
  include Rockhall::ModsSubjects

  set_terminology do |t|
    t.root(:path=>"mods", :xmlns=>"http://www.loc.gov/mods/v3", :schema=>"http://www.loc.gov/standards/mods/v3/mods-3-2.xsd")

    # xml:lang attribute is defined here, but not used
    t.title_info(:path=>"titleInfo", :attributes=>{:type=>:none}) {
      t.main_title(:path =>"title", :label=>"Title")
      t.sub_title(:path=>"subTitle", :label=>"Subtitle")
      t.part_number(:path=>"partNumber", :label=>"Part Number")
      t.part_name(:path=>"partName", :lable=>"Part Name" )
    }

    t.other_title_info(:path=>"titleInfo", :attributes=>{:type=>"alternative title"}) {
      t.other_title(:path=>"title", :label=>"Other Title")
    }

    # Proxy field used by Hydrangea for displaying the title in search results
    t.title(:proxy=>[:title_info, :main_title])

    # This is a mods:name.  The underscore is purely to avoid namespace conflicts.
    t.name_ {
      # this is a namepart
      t.namePart(:type=>:string, :label=>"generic name")
      t.role(:ref => [:role])
      t.date(:path=>"namePart", :attributes=>{:type=>"date"})
      t.last_name(:path=>"namePart", :attributes=>{:type=>"family"})
      t.first_name(:path=>"namePart", :attributes=>{:type=>"given"}, :label=>"first name")
      t.terms_of_address(:path=>"namePart", :attributes=>{:type=>"termsOfAddress"})
    }
    # lookup :person, :first_name
    t.person(:ref=>:name, :attributes=>{:type=>"personal"}, :index_as=>[:facetable])
    t.corporate(:ref=>:name, :attributes=>{:type=>"corporate"}, :index_as=>[:facetable])
    t.conference(:ref=>:name, :attributes=>{:type=>"conference"}, :index_as=>[:facetable])
    t.role {
      t.text(:path=>"roleTerm",:attributes=>{:type=>"text"})
      t.code(:path=>"roleTerm",:attributes=>{:type=>"code"})
    }

    t.resource(:path =>"typeOfResource", :label=>"Type of Resource")

    t.language(:attributes=>{:type=>"text"})

    t.location {
      t.url(:path=>"url", :label=>"Handle")
    }

    # The archival_image model needs this file size info
    # It is entered automatically at ingest via Hydra::GenericContent
    # User will not modify the value
    t.physical_description(:path=>"physicalDescription") {
      t.extent
    }

    t.abstract(:label=>"Abstract")
    t.note(:label=>"Details", :attributes=>{:type=>:none})
    t.contents(:path=>"tableOfContents", :label=>"Contents")

    t.subject(:attributes=>{:authority=>"lcsh"}) {

      t.personal(:path=>"name", :attributes=>{:type=>"personal"}) {
        t.last_name(:path=>"namePart", :attributes=>{:type=>"family"})
        t.first_name(:path=>"namePart", :attributes=>{:type=>"given"})
        t.terms_of_address(:path=>"namePart", :attributes=>{:type=>"termsOfAddress"})
        t.date(:path=>"namePart", :attributes=>{:type=>"date"})
      }
      t.corporate(:path=>"name", :attributes=>{:type=>"corporate"}) {
        t.namePart
      }
      t.conference(:path=>"name", :attributes=>{:type=>"conference"}) {
        t.namePart
      }
      t.title_info(:path=>"titleInfo") {
        t.title(:path =>"title")
        t.sub_title(:path=>"subTitle")
        t.part_number(:path=>"partNumber")
        t.part_name(:path=>"partName")
      }
      t.topic
      t.temporal
      t.genre
      t.geographic

    }

    t.program(:path=>"relatedItem", :label=>"Educational Program", :attributes=>{:type=>"series"}) {
      t.name(:attributes=>{:type=>"corporate", :authority=>"naf"}) {
        t.name_part(:path=>"namePart")
      }
      t.title_info(:path=>"titleInfo") {
        t.title
        t.sub_title(:path=>"subTitle")
        t.part_number(:path=>"partNumber")
        t.part_name(:path=>"partName")
      }
    }

    t.citation(:path=>"note", :label=>"Bibliographic citation", :attributes=>{:type=>"preferred citation"})

    # TODO: can't update this value
		# See Jira, DAM-10
    t.guidelines(:path=>"accessCondition") {
      t.link(:path=>{:attribute=>("xlink:href").to_s})
    }

    t.related_item(:path=>"relatedItem", :label=>"Original item", :attributes=>{:type=>"original"}) {
      t.origin_info(:path=>"originInfo") {
        t.place(:attributes=>{:type=>"text"})
        t.publisher
        t.copyright(:path=>"copyrightDate")
        t.date_issued(:path=>"dateIssued")
        t.date_created(:path=>"dateCreated")
      }
      t.physical_description(:path=>"physicalDescription") {
        t.format(:attributes=>{:authority=>"gmpc"})
        t.extent
      }
      t.location {
          t.shelf_locator(:path=>"shelfLocator")
      }
    }

    t.source(:path=>"relatedItem", :label=>"Source collection", :attributes=>{:type=>"host"}) {
      t.name {
        t.name_part(:path=>"namePart", :attributes=>{:type=>"corporate"})
      }
      t.identifier(:label=>"Collection number")
      t.location {
        t.physical_location(:path=>"physicalLocation", :label=>"Repository")
      }
      t.access(:path=>"accessCondition", :label=>"Access restrictions", :attributes=>{:type=>"access restrictions"})
      t.rights(:path=>"accessCondition", :label=>"Rights information", :attributes=>{:type=>"rights information"})
    }

  end


  # Generates an empty Mods Article (used when you call ModsImage.new without passing in existing xml)
  def self.xml_template
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.mods(:version=>"3.3", "xmlns:xlink"=>"http://www.w3.org/1999/xlink",
        "xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
        "xmlns"=>"http://www.loc.gov/mods/v3",
        "xsi:schemaLocation"=>"http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-3.xsd") {

        xml.titleInfo(:displayLabel=>"Title") {
          xml.title
          xml.subTitle
          xml.partNumber
          xml.partName
        }

        xml.titleInfo(:type=>"alternative title", :displayLabel=>"Other title") {
          xml.title
        }

        xml.name(:type=>"personal", :authority=>"naf") {
          xml.namePart(:type=>"given")
          xml.namePart(:type=>"family")
          xml.namePart(:type=>"date")
          xml.namePart(:type=>"termsOfAddress")
          xml.role {
            xml.roleTerm(:authority=>"marcrelator", :type=>"text")
          }
        }

        xml.typeOfResource

        xml.language(:type=>"text")

        xml.location {
          xml.url(:displayLabel=>"Handle")
        }

        # The archival_image model needs this file size info
        # It is entered automatically at ingest via Hydra::GenericContent
        # User will not modify the value
        xml.physicalDescription {
          xml.extent
        }

        xml.abstract(:displayLabel=>"Abstract")
        xml.note(:displayLabel=>"Details")
        xml.tableOfContents(:displayLabel=>"Contents")

        xml.relatedItem(:type=>"series", :displayLabel=>"Educational Program") {
          xml.name(:type=>"corporate", :authority=>"naf") {
            xml.namePart
          }
          xml.titleInfo {
            xml.title
            xml.subTitle
            xml.partNumber
            xml.partName
          }
        }

        xml.note(:type=>"preferred citation", :displayLabel=>"Bibliographic citation")

        xml.accessCondition(("xlink:href").to_sym => "", :type=>"use and reproduction")

        xml.relatedItem(:type=>"original", :displayLabel=>"Original item") {
          xml.originInfo {
            xml.place(:type=>"text")
            xml.publisher
            xml.copyrightDate
            xml.dateIssued
            xml.dateCreated
          }
          xml.physicalDescription {
            xml.extent
            xml.format(:authority=>"gmpc")
          }
          xml.location {
            xml.shelfLocator
          }
        }

        xml.relatedItem(:type=>"host", :displayLabel=>"Source collection") {
          xml.name(:type=>"corporate") {
            xml.namePart
          }
          xml.identifier(:displayLabel=>"Collection number")
          xml.location {
            xml.physicalLocation(:displayLabel=>"Repository")
          }
          xml.accessCondition(:type=>"access restrictions", :displayLabel=>"Access restrictions")
          xml.accessCondition(:type=>"rights information", :displayLabel=>"Rights information")
        }

      }

    end
    return builder.doc
  end

	def to_solr(solr_doc=Solr::Document.new)
		super(solr_doc)
		#extract_person_full_names.each {|pfn| solr_doc.merge!(pfn) }
		solr_doc.merge!(:object_type_facet => "Image")

		# Add topics
		topics = Array.new
		self.find_by_terms(:subject, :topic).each { |topic| topics << topic.text }
    solr_doc.merge!(:topic_tag_facet => topics)

    # Add event/series
    events = Array.new
    self.find_by_terms(:subject, :conference, :namePart).each { |conf| events << conf.text }
    program = self.find_by_terms(:program, :name, :name_part).first.text
    events << program unless program.empty?
    solr_doc.merge!(:event_facet => events)

    # Add genre
    genres = Array.new
    self.find_by_terms(:subject, :genre).each { |genre| genres << genre.text }
    solr_doc.merge!(:genre_facet => genres)

    # Add collection
    coll =  self.find_by_terms(:source, :name, :name_part).first
    solr_doc.merge!(:collection_facet => coll.text.strip) unless coll.nil?

		solr_doc
	end

end
end

