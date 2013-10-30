require 'spec_helper'

describe "Relators" do

  it "should return a list of available relators" do
    Rockhall.relators.should include :marc
    Rockhall.relators.should include :pbcore
    Rockhall.relators.should include :lc
  end

  it "should include marc terms" do
    Rockhall.relators(:marc)["author"].should == "http://id.loc.gov/vocabulary/relators/aut"
  end

  it "should include pbcore terms" do
    Rockhall.relators(:pbcore)["distributor"].should == "http://pbcore.org/vocabularies/publisherRole#distributor"
  end

  it "should include LC terms" do
    Rockhall.relators(:lc)["concept"].should == "http://id.loc.gov/authorities/sh2007025014#concept"
  end

end