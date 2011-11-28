module Rockhall::PbcoreMethods

  # Module for inserting different types of PBcore xml nodes into
  # an existing PBcore document

  module ClassMethods

    def publisher_template(opts={})
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.pbcorePublisher {
          xml.publisher
          xml.publisherRole(:source=>"PBCore publisherRole")
        }
      end
      return builder.doc.root
    end

    def contributor_template(opts={})
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.pbcoreContributor {
          xml.contributor
          xml.contributorRole(:source=>"MARC relator terms")
        }
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