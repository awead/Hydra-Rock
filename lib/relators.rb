module Relators

  def self.marc
    {
      "recipient" => "http://id.loc.gov/vocabulary/relators/rcp",
      "performer" => "http://id.loc.gov/vocabulary/relators/prf",
    }
  end

  def self.pbcore
    {
      "presenter" => "http://pbcore.org/vocabularies/publisherRole#presenter",
    }
  end

  def self.lc
    {
      "concept"  => "http://id.loc.gov/authorities/sh2007025014#concept",
    }
  end


end