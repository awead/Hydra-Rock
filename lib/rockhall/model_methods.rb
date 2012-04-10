module Rockhall::ModelMethods

  # Call insert_subject on the descMetadata datastream
  def insert_subject(type, opts={})
    ds = self.datastreams["descMetadata"]
    node, index = ds.insert_subject(type,opts)
    return node, index
  end

  # Call remove_contributor on the descMetadata datastream
  # We only need the numbered index node since type is irrelevant
  def remove_subject(index)
    ds = self.datastreams["descMetadata"]
    result = ds.remove_subject(index)
    return result
  end

  # Call the insert_node method for PBcore xml
  def insert_node(type, opts={})
    ds = self.datastreams["descMetadata"]
    node, index = ds.insert_node(type,opts)
    return node, index
  end

  # Call the remove_node method for PBcore xml
  def remove_node(type, index)
    ds = self.datastreams["descMetadata"]
    result = ds.remove_node(type,index)
    return result
  end

  # Adds depositor information
  def apply_depositor_metadata(depositor_id)
    self.depositor = depositor_id
    super
  end

  # Removes any child objects that linked to the parent via RELS-EXT
  def remove_file_objects
    if self.file_objects.count > 0
      self.file_objects.each do |obj|
        ActiveFedora::Base.load_instance(obj.pid).delete
      end
      return true
    else
      return false
    end
  end

  # Returns an array of child video objects based on the child's Fedora label
  def external_video(type)
    results = Array.new
    self.file_objects.each do |obj|
      if type.to_s == obj.label
        results << obj
      end
    end
    return results
  end

  # Returns a hash of arrays.  Each array is set of child objects based on the presence of
  # particulr datastream name.
  def videos
    results = Hash.new
    u_files = Array.new
    p_files = Array.new
    a_files = Array.new
    self.file_objects.each do |obj|
      if obj.datastreams.keys.include?("PRESERVATION1")
        p_files << obj
      elsif obj.datastreams.keys.include?("ACCESS1")
        a_files << obj
      else
        u_files << obj
      end
    end
    results[:unknown]  = u_files
    results[:original] = p_files
    results[:h264]     = a_files
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

  # Used in conjuction with Rockhall::Discovery, this method will return additional solr fields
  # that need to be included when an object is exported to another solr index.
  def addl_solr_fields
    solr_doc = Hash.new
    solr_doc.merge!(:access_file_s => self.access_file)
    solr_doc.merge!(:format_dtl_display => self.access_format)
  end

end
