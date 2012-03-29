require "hydra"

class DigitalVideo < ArchivalVideo

  has_metadata :name => "descMetadata", :type => Rockhall::PbcoreDigitalDocument do |m|
  end

end
