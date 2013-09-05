require 'spec_helper'

describe ArchivalFileRdfDatastream do

  let (:ds) do
    mock_obj = double(:mock_obj, :pid=>'test:1234', :new? => true)
    ds = ArchivalFileRdfDatastream.new(mock_obj)
  end

  #before :each do
  #  @ds = ArchivalFileRdfDatastream.new nil, nil
  #end

  it "should have many contributors" do
    p = ArchivalFileRdfDatastream::Person.new(ds.graph)
    p.name = 'Baker, R. Lisle'
    p.role = 'Director'
    ds.contributor = [p]
    ds.contributor.first.name.should == ['Baker, R. Lisle']
  end

end