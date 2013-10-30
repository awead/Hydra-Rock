module Rockhall
  extend ActiveSupport::Autoload

  autoload :Models
  autoload :Controllers
  autoload :Discovery
  autoload :Exports
  autoload :Headings

  def self.relators type=nil
    return [:marc, :pbcore, :lc] if type.nil?
    self.respond_to?(type.to_s+"_relators") ? self.send(type.to_s+"_relators") : nil
  end

  def self.jetty_clean(pidspace=nil)
    raise "You're trying to clean out your production Fedora instance!!" if Rails.env == "production"

    solr = RSolr.connect :url => Blacklight.solr.uri.to_s
    response = solr.get 'select', :params => {:q => '*:*', :qt=> 'document', :fl => 'id', :rows => '200'}

    response["response"]["docs"].each do |doc|
      id = doc["id"]
      namespace, number = id.split(/:/)
      ActiveFedora::Base.find(id).delete if namespace == pidspace or pidspace.nil?
    end
  end

  private

  def self.marc_relators
    {
      ""              => "",
      "annotator"     => "http://id.loc.gov/vocabulary/relators/ann",
      "artist"        => "http://id.loc.gov/vocabulary/relators/art",
      "author"        => "http://id.loc.gov/vocabulary/relators/aut",
      "choreographer" => "http://id.loc.gov/vocabulary/relators/chr",
      "commentator"   => "http://id.loc.gov/vocabulary/relators/cmm",
      "composer"      => "http://id.loc.gov/vocabulary/relators/cmp",
      "conductor"     => "http://id.loc.gov/vocabulary/relators/cnd",
      "creator"       => "http://id.loc.gov/vocabulary/relators/cre",
      "depicted"      => "http://id.loc.gov/vocabulary/relators/dpc",
      "director"      => "http://id.loc.gov/vocabulary/relators/drt",
      "donor"         => "http://id.loc.gov/vocabulary/relators/dnr",
      "editor"        => "http://id.loc.gov/vocabulary/relators/edt",
      "honoree"       => "http://id.loc.gov/vocabulary/relators/hnr",
      "host"          => "http://id.loc.gov/vocabulary/relators/hst",
      "interviewee"   => "http://id.loc.gov/vocabulary/relators/ive",
      "interviewer"   => "http://id.loc.gov/vocabulary/relators/ivr",
      "lyricist"      => "http://id.loc.gov/vocabulary/relators/lyr",
      "narrator"      => "http://id.loc.gov/vocabulary/relators/nrt",
      "performer"     => "http://id.loc.gov/vocabulary/relators/prf",
      "photographer"  => "http://id.loc.gov/vocabulary/relators/pht",
      "producer"      => "http://id.loc.gov/vocabulary/relators/pro",
      "recipient"     => "http://id.loc.gov/vocabulary/relators/rcp",
      "speaker"       => "http://id.loc.gov/vocabulary/relators/spk",
    }
  end

  def self.pbcore_relators
    {
      ""                 => "",
      "presenter"        => "http://pbcore.org/vocabularies/publisherRole#presenter",
      "copyright holder" => "http://pbcore.org/vocabularies/publisherRole#copyright-holder",
      "distributor"      => "http://pbcore.org/vocabularies/publisherRole#distributor",
      "publisher"        => "http://pbcore.org/vocabularies/publisherRole#publisher",
      "release agent"    => "http://pbcore.org/vocabularies/publisherRole#realease-agent",
    }
  end

  def self.lc_relators
    {
      "concept"  => "http://id.loc.gov/authorities/sh2007025014#concept",
    }
  end  
  
end
