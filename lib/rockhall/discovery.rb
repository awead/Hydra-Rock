require 'mediashelf/active_fedora_helper'
class Rockhall::Discovery

  include Hydra::RepositoryController
  include Hydra::AccessControlsEnforcement
  include Blacklight::SolrHelper

  # This is a push method that queries the Solr index used by Hydra
  # for publicly available objects and sends them to another solr index
  # Right now, it's only doing images

  # adds objects to solr index
  def self.get_objects

    # query to return all objects in solr with discovery set to public
    results = Blacklight.solr.find( :q => "access_group_t:public and object_type_facet:Image" )
    
    # connect to our other solr index
    solr = solr_connect

    # update each result
    results["response"]["docs"].each do |r|
            
      contributors = get_contributors(r, "All")
      authors = get_contributors(r, "Creator")
      authors = contributors if authors.nil?
      
      subjects = Array.new
      subjects.push(get_subjects(r))
      
      topics = Array.new
      topics.push(contributors) unless contributors.empty?
      topics.push(subjects) unless subjects.empty?
      
      solr_doc = {
        :format => "image",
        :id => r["id"],
        :title_display => r["title_info_main_title_t"],
        :title_addl_display => r["other_title_info_t"],
        :author_display => authors.join("; "),
        :contributors_display => contributors.join("; "),
        :language_facet => r["mods_0_language_t"],
        :summary_display => r["mods_0_abstract_t"],
        :notes_display => r["mods_0_note_t"],
        :contents_display => r["mods_0_contents_t"],
        :subject_topic_facet => topics.flatten.uniq,
        :subject_display => subjects.join("; "),
        :series_display => r["mods_0_program_0_title_info_0_title_t"],
        :title_series_t => r["mods_0_program_0_name_0_name_part_t"],
        :access_display => r["mods_0_source_0_access_t"],
        :text => r["text"]
      }
      solr.add solr_doc
      solr.commit
    end
    
  end

  # delete any existing objects
  # used prior to an update
  def self.delete_objects
    solr = solr_connect
    results = solr.find( :fq => "{!raw f=format}image", :qt => "search", "facet.field"=>["format"])
    results["response"]["docs"].each do |r|
      solr.delete_by_id r["id"]
      solr.commit
    end
  end
  
  
  def self.solr_connect
    solr = RSolr.connect :url => 'http://localhost:8984/solr/blacklight'
  end
    
  private
  
  def self.get_contributors(doc,role)
    results = Array.new
    personal = get_personal_contributors(doc, role)
    corporate = get_other_contributors(doc, "corporate", role)
    conference = get_other_contributors(doc, "conference", role)    
    unless personal.nil?
      results.push(personal)
    end
    unless corporate.nil?
      results.push(corporate)
    end
    unless conference.nil?
      results.push(conference)
    end
    return results unless results.empty?
  end
  
  def self.get_personal_contributors(doc,role,opts={})
    contributors = Array.new
    i = 0
    while i < 20
      if role == "All"
        unless doc["mods_0_person_#{i}_last_name_t"].nil? and doc["mods_0_person_#{i}_first_name_t"].nil?
          contributors.push( [doc["mods_0_person_#{i}_last_name_t"], doc["mods_0_person_#{i}_first_name_t"]].join(", ") )
        end
      else
        persons_roles = doc["mods_0_person_#{i}_role_t"].map{|w|w.strip.downcase} unless doc["mods_0_person_#{i}_role_t"].nil?
        if persons_roles and persons_roles.include?(role.downcase)
          unless doc["mods_0_person_#{i}_last_name_t"].nil? and doc["mods_0_person_#{i}_first_name_t"].nil?
            contributors.push( [doc["mods_0_person_#{i}_last_name_t"], doc["mods_0_person_#{i}_first_name_t"]].join(", ") )
          end
        end
      end
      i += 1
    end
    return contributors unless contributors.empty?
  end
  
  def self.get_other_contributors(doc,type,role,opts={})
    contributors = Array.new
    i = 0
    while i < 20
      if role == "All"
        unless doc["mods_0_#{type}_#{i}_namePart_t"].nil?
          contributors.push( doc["mods_0_#{type}_#{i}_namePart_t"] )
        end
      else
        persons_roles = doc["mods_0_#{type}_#{i}_role_t"].map{|w|w.strip.downcase} unless doc["mods_0_#{type}_#{i}_role_t"].nil?
        if persons_roles and persons_roles.include?(role.downcase)
          unless doc["mods_0_#{type}_#{i}_namePart_t"].nil?
            contributors.push( doc["mods_0_#{type}_#{i}_namePart_t"] )
          end
        end     
      end
      i += 1       
    end
    return contributors unless contributors.empty?
  end


  def self.get_subjects(doc,opts={})
    subjects = Array.new
    i = 0
    while i < 20
      unless doc["mods_0_subject_#{i}_personal_0_first_name_t"].nil? and doc["mods_0_subject_#{i}_personal_0_last_name_t"].nil?
        subjects.push( [doc["mods_0_subject_#{i}_personal_0_last_name_t"], doc["mods_0_subject_#{i}_personal_0_first_name_t"]].join(", ") )
      end
      unless doc["mods_0_subject_#{i}_corporate_0_namePart_t"].nil?
        subjects.push( doc["mods_0_subject_#{i}_corporate_0_namePart_t"] )
      end
      unless doc["mods_0_subject_#{i}_conference_0_namePart_t"].nil?
        subjects.push( doc["mods_0_subject_#{i}_conference_0_namePart_t"] )
      end
      unless doc["mods_0_subject_#{i}_geographic_t"].nil?
        subjects.push( doc["mods_0_subject_#{i}_geographic_t"] )
      end
      unless doc["mods_0_subject_#{i}_title_info_0_title_t"].nil?
        subjects.push( doc["mods_0_subject_#{i}_title_info_0_title_t"] )
      end
      unless doc["mods_0_subject_#{i}_topic_t"].nil?
        subjects.push( doc["mods_0_subject_#{i}_topic_t"] )
      end
      i += 1
    end
    return subjects unless subjects.empty?
  end

end
