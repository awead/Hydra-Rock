module Rockhall::ModelMethods

  # Adds depositor information
  def apply_depositor_metadata(depositor_id)
    self.depositor = depositor_id
    super
  end

  # Removes any child objects that linked to the parent via RELS-EXT
  def remove_external_videos
    if self.external_videos.count > 0
      self.external_videos.each do |obj|
        ActiveFedora::Base.find(obj.pid).delete
      end
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
  def videos
    results = Hash.new
    results[:unknown]  = Array.new
    results[:original] = Array.new
    results[:h264]     = Array.new
    self.external_videos.each do |obj|
      if obj.datastreams.keys.include?("PRESERVATION1")
        results[:original] << obj
      elsif obj.datastreams.keys.include?("ACCESS1")
        results[:h264] << obj
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

  # Used in conjuction with Rockhall::Discovery, this method will return additional solr fields
  # that need to be included when an object is exported to another solr index.
  def addl_solr_fields
    solr_doc = Hash.new
    access_videos = Array.new
    self.videos[:h264].each do |ev|
      access_videos << ev.name.first
    end
    solr_doc.merge!(:access_file_s => access_videos)
    solr_doc.merge!(:format_dtl_display => self.access_format)
  end

  def apply_default_permissions
    self.datastreams["rightsMetadata"].update_permissions( "group"=>{"archivist"=>"edit"} )
    self.datastreams["rightsMetadata"].update_permissions( "group"=>{"reviewer"=>"edit"} )
    self.datastreams["rightsMetadata"].update_permissions( "group"=>{"donor"=>"read"} )
    self.save
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

end
