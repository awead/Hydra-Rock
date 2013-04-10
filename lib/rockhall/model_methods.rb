module Rockhall::ModelMethods

  # Adds depositor information
  def apply_depositor_metadata(depositor_id)
    self.depositor = depositor_id
    super
  end

  # Removes h264 and original child video objects, but not objects that represent tapes
  def remove_external_videos files = Array.new
    self.videos[:original].collect { |o| files << o }
    self.videos[:h264].collect     { |o| files << o }
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
  def videos
    results = Hash.new
    results[:unknown]  = Array.new
    results[:original] = Array.new
    results[:h264]     = Array.new
    results[:tape]     = Array.new
    self.external_videos.each do |obj|
      if obj.datastreams.keys.include?("PRESERVATION1")
        results[:original] << obj
      elsif obj.datastreams.keys.include?("ACCESS1")
        results[:h264] << obj
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

  # Transfers the external videos from one ArchivalVideo to another
  # Takes an ArchivalVideo object as the source, and returns the
  # object, reloaded, and emptied of its associated video objects.
  def transfer_videos_from source
    return nil if source.external_videos.empty?
    source.external_videos.each do |v|
      v.remove_relationship(:is_part_of, source)
      v.parent = self
      v.save
    end
    source.reload
  end


end
