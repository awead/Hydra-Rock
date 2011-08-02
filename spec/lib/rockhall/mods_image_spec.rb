require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require "active_fedora"
require "nokogiri"
require "equivalent-xml"

describe Rockhall::ModsImage do
  
  before(:each) do
    Fedora::Repository.stubs(:instance).returns(stub_everything())
    @object_ds = Rockhall::ModsImage.new
  end

  describe ".new" do
    it "should initialize a new mods article template if no xml is provided" do
      article_ds = Rockhall::ModsImage.new
      article_ds.ng_xml.to_xml.should == Rockhall::ModsImage.xml_template.to_xml
    end
  end
  
  describe "insert_person_contributor" do
    it "should generate a new person contributor adding it to the existing one in the template" do
      @object_ds.find_by_terms(:mods, :person).length.should == 1
      @object_ds.dirty?.should be_false
      node, index = @object_ds.insert_contributor("person")
      @object_ds.dirty?.should be_true
      
      @object_ds.find_by_terms(:mods, :person).length.should == 2
      node.to_xml.should == Rockhall::ModsImage.person_template.to_xml
      index.should == 1
      
      node, index = @object_ds.insert_contributor("person")
      @object_ds.find_by_terms(:mods, :person).length.should == 3
      index.should == 2
    end
  end
  
  describe "insert new contributors" do
    it "should generate a new corporate and conference contributor" do
    
      @object_ds.dirty?.should be_false
      ["corporate", "conference"].each do |type|
        @object_ds.find_by_terms(:mods, type.to_sym).length.should == 0
        node, index = @object_ds.insert_contributor(type)
        @object_ds.dirty?.should be_true
        
        @object_ds.find_by_terms(:mods, type.to_sym).length.should == 1
        node.to_xml.should == Rockhall::ModsImage.send("#{type}_template").to_xml
        index.should == 0
        
        node, index = @object_ds.insert_contributor(type)
        @object_ds.find_by_terms(:mods, type.to_sym).length.should == 2
        index.should == 1
      end
      
    end
  end    
  
  describe "remove_contributor" do
    it "should remove the corresponding contributor from the xml and then mark the datastream as dirty" do
      @object_ds.find_by_terms(:mods, :person).length.should == 1
      result = @object_ds.remove_contributor("person", "0")
      @object_ds.find_by_terms(:mods, :person).length.should == 0
      @object_ds.should be_dirty
    end
  end
  
  
  describe "insert_subjects" do
    it "should generate one new subject of each type, personal, corporate, and conference, inserting them into the current xml, treating strings and symbols equally to indicate type and marking the datastream as dirty" do
    
      @object_ds.dirty?.should be_false
      count = 0
      
      ["personal", "conference", "corporate", "title_info", "topic", "geographic"].each do |name|
        @object_ds.find_by_terms(:mods, :subject, name.to_sym).length.should == 0
        node, index = @object_ds.insert_subject(name)
        index.should == count
        count = count + 1        
        node.to_xml.should == Rockhall::ModsImage.subject_template(name).to_xml      
        @object_ds.find_by_terms(:mods, :subject, name.to_sym).length.should == 1     
      end
      
      @object_ds.dirty?.should be_true
      
    end
  end

  
  describe "remove_subject" do
    it "should delete the existing personal subject from the xml template and mark the datastream as dirty" do
      @object_ds.insert_subject(:personal)
      @object_ds.find_by_terms(:mods, :subject, :personal).length.should == 1
      result = @object_ds.remove_subject("0")
      @object_ds.find_by_terms(:mods, :subject, :personal).length.should == 0
      @object_ds.find_by_terms(:subject).length.should == 0      
      @object_ds.dirty?.should be_true
    end
    
    it "should add an additional personal subject, then remove it, ensuring the original one is still there" do
      @object_ds.insert_subject(:personal)
      @object_ds.find_by_terms(:mods, :subject, :personal).length.should == 1    
      @object_ds.insert_subject(:personal)
      @object_ds.dirty?.should be_true
      @object_ds.find_by_terms(:mods, :subject, :personal).length.should == 2
      result = @object_ds.remove_subject("1")
      @object_ds.find_by_terms(:mods, :subject, :personal).length.should == 1
      result = @object_ds.remove_subject("0")
      @object_ds.find_by_terms(:mods, :subject, :personal).length.should == 0
      @object_ds.find_by_terms(:subject).length.should == 0                
    end
  end
  
  
  describe "contibutors_vs_subjects" do
    it "should insert and delete various subject and contributor nodes, insuring the two do not interfere with one another" do
    
      @object_ds.dirty?.should be_false
      @object_ds.insert_subject(:personal)
      
      ["conference", "corporate"].each do |type|
        # Insert :subject type
        # Note: we're not tracking the indexes... we did that earlier
        @object_ds.find_by_terms(:mods, :subject, type.to_sym).length.should == 0
        node, index = @object_ds.insert_subject(type.to_sym)

        @object_ds.dirty?.should be_true
        @object_ds.find_by_terms(:mods, :subject, type.to_sym).length.should == 1
        
        # Insert :name type
        @object_ds.find_by_terms(:mods, type.to_sym).length.should == 0
        node, index = @object_ds.insert_contributor(type.to_sym)
        @object_ds.find_by_terms(:mods, type.to_sym).length.should == 1
        
        # We have 2 kinds of type
        #@object_ds.find_by_terms(type.to_sym).length.should == 2
        
        result = @object_ds.remove_contributor(type.to_s, "0")
        @object_ds.find_by_terms(:mods, type.to_sym).length.should == 0
        @object_ds.find_by_terms(:mods, :subject, type.to_sym).length.should == 1
        # Remember that we're tracking each subject numerically regardless of type,
        # so our first pre-existing subject is 0, and the one we just added is 1;
        # therefore, we want to delete index number 1 
        result = @object_ds.remove_subject("1")
        @object_ds.find_by_terms(:mods, :subject, type.to_sym).length.should == 0
        # make sure our original is still there
        @object_ds.find_by_terms(:mods, :subject, :personal).length.should == 1
      end
  
    end
  end
  
  describe "digital_file" do
  	it "should update the size of the digital file" do
  		@object_ds.update_indexed_attributes([:mods, :physical_description, :extent] => "digital")
  		@object_ds.update_indexed_attributes([:related_item, :physical_description, :extent] => "physical")
  		@object_ds.get_values( [:mods, :physical_description, :extent] ).first.should == "digital"
  		@object_ds.get_values( [:related_item, :physical_description, :extent] ).first.should == "physical"
  	end
	end
  
  
  describe ".update_indexed_attributes" do
    it "should work for all of the fields we want to display" do
      [ [:mods, :title_info, :main_title],
        [:mods, :title_info, :sub_title],
        [:mods, :title_info, :part_number],
        [:mods, :title_info, :part_name],
        [:mods, :other_title_info, :other_title],
        [:mods, :name, :last_name],
        [:mods, :name, :first_name],
        [:mods, :name, :terms_of_address],
        [:mods, :name, :date],
        [:mods, :name, :role],
        [:resource],
        [:language],
        [:location, :url],
        [:mods, :physical_description, :extent],
        [:abstract],
        [:mods, :note],
        [:mods, :subject, :personal, :last_name],
        [:mods, :subject, :personal, :first_name],
        [:mods, :subject, :personal, :terms_of_address],
        [:mods, :subject, :personal, :date],
        [:program, :name, :name_part],
        [:program, :title_info, :title],
        [:program, :title_info, :sub_title],
        [:program, :title_info, :part_number],
        [:program, :title_info, :part_name],
        [:mods, :citation],
        [:mods, :guidelines],
        [:related_item, :origin_info, :place],
        [:related_item, :origin_info, :publisher],
        [:related_item, :origin_info, :copyright],
        [:related_item, :origin_info, :date_issued],
        [:related_item, :origin_info, :date_created],
        [:related_item, :physical_description, :format],
        [:related_item, :physical_description, :extent],
        [:related_item, :location, :shelf_locator],
        [:source, :name, :name_part],
        [:source, :identifier],
        [:source, :location, :physical_location],
        [:source, :access],
        [:source, :rights],
        [:contents] ].each do |pointer|
        test_val = "#{pointer.last.to_s} value"
        @object_ds.update_indexed_attributes( {pointer=>{"0"=>test_val}} )
        @object_ds.get_values(pointer).first.should == test_val
        @object_ds.get_values(pointer).length.should == 1
      end
    end
    
    # Sent note to HydraTech about this
    # get_values does not support searching nods both with and without type attributes
    # workaround is to use type=""
    it "should update a two nodes, one with a type and one without, using single values" do
      @object_ds.update_indexed_attributes( [:note] => "Test note" )
      @object_ds.update_indexed_attributes( [:citation] => "Test citation" )
      @object_ds.get_values([:note]).first.should == "Test note"
      @object_ds.get_values([:note]).length.should == 1
      @object_ds.get_values([:citation]).first.should == "Test citation"
      @object_ds.get_values([:citation]).length.should == 1
      
      @object_ds.update_indexed_attributes( [:mods, :title_info, :main_title] => "Test title" )
      @object_ds.update_indexed_attributes( [:mods, :other_title_info, :other_title] => "Test alt title" )
      @object_ds.get_values([:mods, :title_info, :main_title]).first.should == "Test title"
      @object_ds.get_values([:mods, :title_info, :main_title]).length.should == 1
      @object_ds.get_values([:mods, :other_title_info, :other_title]).first.should == "Test alt title"
      @object_ds.get_values([:mods, :other_title_info, :other_title]).length.should == 1          
    end
    
         
    
  end
  
  describe "#xml_template" do
    it "should return an empty xml document matching an exmplar" do
      # See DAM-17
      
      # Add each type of contributor and subject to our existing template
      @object_ds.insert_contributor(:corporate)
      @object_ds.insert_contributor(:conference)
      @object_ds.insert_subject(:personal)
      @object_ds.insert_subject(:conference)
      @object_ds.insert_subject(:corporate)
      @object_ds.insert_subject(:title_info)
      @object_ds.insert_subject(:topic)
      @object_ds.insert_subject(:geographic)
      
      # Load example fixture
      f = File.open("#{RAILS_ROOT}/spec/fixtures/rockhall/mods_article_template.xml")
      ref_node = Nokogiri::XML(f)
      f.close
      
      # Nokogiri-fy our sample document
      sample_node = Nokogiri::XML(@object_ds.to_xml)
      
      EquivalentXml.equivalent?(ref_node, sample_node, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
      
    end
  end
  
end
