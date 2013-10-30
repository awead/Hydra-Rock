module Rockhall::Models::VideoFiles
  extend ActiveSupport::Concern

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

  # Removes all external video objects from a parent
  def destroy_external_videos
    self.external_videos.collect { |ev| ev.delete } unless self.external_videos.empty?
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
    results[:original]     = Array.new
    self.external_videos.each do |obj|
      if obj.datastreams.keys.include?("PRESERVATION1")
        results[:preservation] << obj
      elsif obj.datastreams.keys.include?("ACCESS1")
        results[:access] << obj
      elsif obj.generation.first.match("Original")
        results[:original] << obj
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

  def add_thumbnail file = String.new, result = false
    if file.blank?
      unless self.external_video(:h264).count == 0
        path = File.join(RH_CONFIG["location"], self.pid.gsub(/:/,"_"), "data", self.external_video(:h264).first.name.first)
        if File.exists?(path)
          if self.generate_video_thumbnail(path)
            self.datastreams["thumbnail"].content = File.new("tmp/thumb.jpg")
            result = true
          end
        end
      end
    else
      begin
        self.datastreams["thumbnail"].content = File.new(file)
        result = true
      rescue => e
        self.errors.add(:add_thumbnail)
      end
    end
    return result
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