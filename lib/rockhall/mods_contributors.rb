module Rockhall::ModsContributors

  # This module uses the same instance methods from Hydra::ModsContributors
  # but has different class methods for customized XML nodes

  include Hydrangea::ModsContributors
  include Hydra::CommonModsIndexMethods

  module MyClassMethods

    def person_template
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.name(:type=>"personal", :authority=>"naf") {
          xml.namePart(:type=>"family")
          xml.namePart(:type=>"given")
          xml.namePart(:type=>"date")
          xml.namePart(:type=>"termsOfAddress")
          xml.role {
            xml.roleTerm(:type=>"text")
          }
        }
      end
      return builder.doc.root
    end

    def corporate_template
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.name(:type=>"corporate", :authority=>"naf") {
          xml.namePart
          xml.role {
            xml.roleTerm(:type=>"text")
          }
        }
      end
      return builder.doc.root
    end

    def conference_template
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.name(:type=>"conference", :authority=>"naf") {
          xml.namePart
          xml.role {
            xml.roleTerm(:type=>"text")
          }
        }
      end
      return builder.doc.root
    end

  end


  def self.included(klass)
    klass.extend(MyClassMethods)
  end

  # Instance methods included from Hydra::ModsContributors

end

