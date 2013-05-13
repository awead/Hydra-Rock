module Rockhall::ModelMethods

  # Adds depositor information
  def apply_depositor_metadata depositor_id
    self.depositor = depositor_id
    self.rightsMetadata.permissions({:person=>depositor_id}, 'edit') unless self.rightsMetadata.nil?
  end

  # Removes h264 and original child video objects, but not objects that represent tapes
  def remove_external_videos files = Array.new
    self.videos[:preservation].collect { |o| files << o }
    self.videos[:access].collect     { |o| files << o }
    if files.count > 0
      files.collect { |obj| ActiveFedora::Base.find(obj.pid).delete }
      return true
    else
      return false
    end
  end

  # Returns an array of child video objects based on the child's Fedora label
  def external_video(type)
    results = Array.new
    self.external_videos.each do |obj|
      if type.to_s == obj.label
        results << obj
      end
    end
    return results
  end

  # Returns a hash of arrays.  Each array is set of child objects based on the presence of
  # particulr datastream name.
  def videos results = Hash.new
    results[:unknown]  = Array.new
    results[:preservation] = Array.new
    results[:access]     = Array.new
    results[:tape]     = Array.new
    self.external_videos.each do |obj|
      if obj.datastreams.keys.include?("PRESERVATION1")
        results[:preservation] << obj
      elsif obj.datastreams.keys.include?("ACCESS1")
        results[:access] << obj
      elsif obj.generation.first.match("Original")
        results[:tape] << obj
      else
        results[:unknown] << obj
      end
    end
    return results
  end

  def access_file
    unless self.external_video(:h264).empty?
      return self.external_video(:h264).first.datastreams["descMetadata"].get_values(:name)
    end
  end

  def access_format
    unless self.external_video(:h264).empty?
      return self.external_video(:h264).first.datastreams["descMetadata"].get_values(:video_encoding)
    end
  end

  def add_thumbnail file = String.new
    if file.blank?
      unless self.external_video(:h264).count == 0
        path = File.join(RH_CONFIG["location"], self.pid.gsub(/:/,"_"), "data", self.external_video(:h264).first.name.first)
        if File.exists?(path)
          self.generate_video_thumbnail path
          self.datastreams["thumbnail"].content = File.new("tmp/thumb.jpg")
        end
      end
    else
      self.datastreams["thumbnail"].content = file
    end
  end

  def get_thumbnail_url
    unless self.datastreams["thumbnail"].content.nil?
      return (RH_CONFIG["repository"] + "/" + self.datastreams["thumbnail"].url)
    end
  end

  # Transfers the external videos from one ArchivalVideo to another
  # Takes a pid as its argument and returns true or false (with errors)
  def transfer_videos_from_pid pid
    if check_transfer_source(pid)
      source = ArchivalVideo.find(pid)
      source.external_videos.each do |v|
        v.remove_relationship(:is_part_of, source)
        v.parent = self
        v.save
      end
    end
    self.errors.count > 0 ? false : true
  end

  # returns a complete pbcore xml document
  def to_pbcore_xml instantiations = Array.new
    unless self.external_videos.nil?
      self.external_videos.collect { |v| instantiations << v.datastreams["descMetadata"] }
    end
    self.datastreams["descMetadata"].pbc_id = self.pid
    self.datastreams["descMetadata"].remove_node(:note) if self.note.first.blank?
    self.datastreams["descMetadata"].to_pbcore_xml(instantiations)
  end

  def valid_pbcore?
    HydraPbcore.is_valid?(self.to_pbcore_xml)
  end

  # Uses the supplied terms hash to run .update_attributes for each term in the hash.  This method parses
  # the values for the for the term and if they are different than the number present in the object,
  # indicating that nodes either need to be added or removed, it will first remove all the terms present
  # in the object and then update the object with the new set of supplied terms.  Unlike OM's default behavior,
  # this method assumes that you want to replace all the old terms with the new ones in the hash.
  # 
  # If the term is empty, not an array, or matches the same number of values as the existing one, then
  # then no nodes are remove and .update_attributes is called directly.
  def update_metadata terms
    terms.each_key do |term|
      if terms[term].is_a?(Array)
        if self.send(term).count == terms[term].count
          self.update_attributes({term => terms[term]})
        elsif self.send(term).empty?
          self.update_attributes({term => terms[term]})
        else
          self.send(term).each_index { |i| self.descMetadata.remove_node(term.to_s) }
          self.update_attributes({term => terms[term]})
        end
      else
        self.update_attributes({term => terms[term]})
      end
    end
    self.errors.count > 0 ? false : true
  end

  protected 

  def check_transfer_source source
    if !ActiveFedora::Base.exists?(source)
      errors.add(:transfer_videos_from_pid, "Source #{source} does not exist")
      return false
    else
      obj = ArchivalVideo.find(source)
      if obj.external_videos.count == 0
        errors.add(:transfer_videos_from_pid, "Source #{source} has no videos")
        return false
      else
        return true
      end
    end
  end

end
