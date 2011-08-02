module Rockhall::ModsSubjects

  include Hydra::CommonModsIndexMethods

  module ClassMethods

    # Generates a subject template of title, topic or geographic
    def subject_template(type)
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.subject(:authority=>"lcsh") {
        
          case type.to_sym
          when :personal
            xml.name(:type=> "personal") {
              xml.namePart(:type=>"given")
              xml.namePart(:type=>"family")
              xml.namePart(:type=>"date")
              xml.namePart(:type=>"termsOfAddress")
            }
          when :conference
            xml.name(:type=> "conference") {
              xml.namePart
            }
          when :corporate
            xml.name(:type=> "corporate") {
              xml.namePart
            }
          when :title_info
            xml.titleInfo {
              xml.title
              xml.subTitle
              xml.partNumber 
              xml.partName
            }
          when :topic
            xml.topic
            xml.temporal
            xml.genre
          when :geographic
            xml.geographic
          else
            raise "#{type} is not a valid argument for Rockhall::ModsImage.subject_template"
          end
        
        }    
      end
      
      return builder.doc.root
    end
    
  end
  
  
  def self.included(klass)
    klass.extend(ClassMethods)
  end   
  
  
  # This method is exactly like the Hyra::ModsContributor method
  def insert_subject(type, opts={})
    
    node = self.class.subject_template(type.to_sym) 
    nodeset = self.find_by_terms(:mods, :subject)
    
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

  def remove_subject(index)
    # Note: Do not add :mods to the find_by_terms here. It messes it up.
    # We're deleting the numbered subject node, so type is not needed
    self.find_by_terms({ :subject => index.to_i }).first.remove
    self.dirty = true
  end

end
