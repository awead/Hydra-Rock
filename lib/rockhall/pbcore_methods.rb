module Rockhall::PbcoreMethods

  # Module for inserting different types of PBcore xml nodes into
  # an existing PBcore document

  module ClassMethods

    def publisher_template(opts={})
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.pbcorePublisher {
          xml.publisher
          xml.publisherRole(:source=>"PBcore publisherRole", :ref=>"")
        }
      end
      return builder.doc.root
    end

    def contributor_template(opts={})
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.pbcoreContributor {
          xml.contributor
          xml.contributorRole(:source=>"MARC List for Relators", :ref=>"")
        }
      end
      return builder.doc.root
    end

    def genre_template(opts={})
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.pbcoreGenre(:source=>"Library of Congress Subject Headings", :ref=>"")
      end
      return builder.doc.root
    end

    def topic_template(opts={})
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.pbcoreSubject(:subjectType=>"topic", :source=>"Library of Congress Subject Headings", :ref=>"")
      end
      return builder.doc.root
    end

    def series_template(opts={})
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.pbcoreRelation {
          xml.pbcoreRelationType(:source=>"PBCore relationType", :ref=>"http://pbcore.org/vocabularies/relationType#is-part-of") {
            xml.text "Is Part Of"
          }
          xml.pbcoreRelationIdentifier
        }
      end
      return builder.doc.root
    end

    def note_template(opts={})
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.pbcoreAnnotation(:annotationType=>"note")
      end
      return builder.doc.root
    end

    def entity_template
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.pbcoreSubject(:subjectType=>"entity", :source=>"Library of Congress Name Authorities")
      end
      return builder.doc.root
    end

    def era_template
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.pbcoreSubject(:subjectType=>"era", :source=>"Library of Congress Subject Headings")
      end
      return builder.doc.root
    end

    def place_template
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.pbcoreSubject(:subjectType=>"place", :source=>"Library of Congress Subject Headings")
      end
      return builder.doc.root
    end

    def event_template
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.pbcoreSubject(:subjectType=>"event", :source=>"Library of Congress Subject Headings")
      end
      return builder.doc.root
    end

    def episode_template
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.pbcoreTitle(:titleType=>"Episode")
      end
      return builder.doc.root
    end

    def sub_title_template
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.pbcoreTitle(:titleType=>"Subtitle")
      end
      return builder.doc.root
    end

    def alt_title_template
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.pbcoreTitle(:titleType=>"Alternatitve", :annotation=>"Other Title")
      end
      return builder.doc.root
    end

    def caption_template
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.instantiationAlternativeModes
      end
      return builder.doc.root
    end

 end

  def self.included(klass)
    klass.extend(ClassMethods)
  end

  def insert_node(type, opts={})

    unless self.class.respond_to?("#{type}_template".to_sym)
      raise "No XML template is defined for a PBcore node of type #{type}."
    end

    node = self.class.send("#{type}_template".to_sym)
    nodeset = self.find_by_terms(type.to_sym)

    unless nodeset.nil?
      if nodeset.empty?
        self.ng_xml.root.add_child(node)
        index = 0
      else
        nodeset.after(node)
        index = nodeset.length
      end
      self.dirty = true
    end

    return node, index

  end

  def remove_node(type, index)
    if type == "education" or type == "television"
      self.find_by_terms(type.to_sym).slice(index.to_i).parent.remove
    else
      self.find_by_terms(type.to_sym).slice(index.to_i).remove
    end
    self.dirty = true
  end


end