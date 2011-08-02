module Hydra::ModsContributors

  include Hydra::CommonModsIndexMethods

  # This will add an attibute accessor to _instances_ of classes that include the module.
  attr_accessor :my_attribute

  # Class Methods -- These methods will be available on classes that include this Module

  module ClassMethods
      
    def person_template
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.name(:type=>"personal") {
          xml.namePart(:type=>"family")
          xml.namePart(:type=>"given")
          xml.affiliation
          xml.role {
            xml.roleTerm(:type=>"text")
          }
        }
      end
      return builder.doc.root
    end
    
    def type_template(type)
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.name(:type=>"#{type}") {
          xml.namePart
          xml.role {
            xml.roleTerm(:authority=>"marcrelator", :type=>"text")
          }                          
        }
      end
      return builder.doc.root
    end

    # Don't know if anyone is using this or not, but it's included here
    def full_name_template
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.full_name(:type => "personal")
      end
      return builder.doc.root
    end

    # Included here until HYDRA-272 is finished
    # can be replaced by type_template("corporate")
    def organization_template
      type_template("corporate")
    end
    
    # Included here until HYDRA-272 is finished
    # can be replaced by type_template("conference")
    def conference_template
      type_template("conference")
    end 
    
    # Generates a new Grant node
    # This technically isn't a contributor, but I'm leaving it in in case anyone
    # wants to use this module for adding grants
    def grant_template
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.grant {
          xml.organization
          xml.number
        }
      end
      return builder.doc.root
    end
  
  end
    
    
  # Whenever you include ExampleModule in one of your classes, this will be triggered.
  # In this case, we are using this hook to extend that class with ExampleModule::ClassMethods
  def self.included(klass)
    klass.extend(ClassMethods)
  end 
  
  
  # Instance methods

  # insert_contributor
  # Returns xml node based on [type]_template
  # raises exception if template does not exist
  def insert_contributor(type, opts={})
    
    unless self.class.respond_to?("#{type}_template".to_sym) 
      raise "No XML template is defined for contributors of type #{type}. I am: #{self} " 
    end 
    
    node = self.class.send("#{type}_template".to_sym) 
    nodeset = self.find_by_terms(:mods, type.to_sym)
    
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
  
  # insert_type
  # Generic form of contributor that uses [type]
  # as the type attribute for a name node
  def insert_type(type)
  
    node = self.class.type_template(type)
    nodeset = self.find_by_terms(:mods, type.to_sym)
    
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
  
  def remove_contributor(type, index)
    self.find_by_terms( :mods, type.to_sym).slice(index.to_i).remove
    self.dirty = true
  end

end
