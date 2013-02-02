require "spec_helper"

describe Properties do

  describe "when updating one datastream" do
    before do
      class Foo < ActiveFedora::Base
        has_metadata :name => "properties", :type => Properties 
        has_metadata :name => "stuff", :type => Properties
        delegate :collection, :to=> :properties, :unique=>true
        delegate :depositor, :to=> :stuff, :unique=>true
      end
      obj = Foo.new()
      obj.collection = "test value"
      obj.depositor = "Title"
      obj.save

      #Update the object
      obj2 = Foo.find(obj.pid)
      obj2.depositor = "Moo Cow"
      obj2.save

      @obj = Foo.find(obj.pid)
    end

    after do
      Object.send(:remove_const, :Foo)
    end

    it "should have updated the one datastream" do
      @obj.depositor.should == "Moo Cow"
    end
    it "should not have changed the other datastream" do
      @obj.collection.should == "test value"
    end
  end
end