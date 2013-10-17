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

  def update_collection params
    if self.collection.nil?
      self.new_collection(args_for_collection(params[:collection]))
      add_new_archival_series(params[:collection],params[:archival_series]) unless params[:archival_series].empty?
    elsif params[:collection].empty?
      self.delete_collection
      self.delete_archival_series unless self.archival_series.nil?
    else
      update_collection_fields params[:collection] 
      update_archival_series params
    end
  end

  def update_archival_series params
    if self.archival_series.nil?
      add_new_archival_series(params[:collection],params[:archival_series]) unless params[:archival_series].empty?
    elsif params[:archival_series].empty? 
      self.delete_archival_series unless self.archival_series.nil?
    else
      update_archival_series_fields params[:collection], params[:archival_series]
    end
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

  def update_collection_fields ead_id
    args = args_for_collection(ead_id)
    self.collection = args[:name]
    self.collection_uri = args[:ref]
    self.collection_authority = args[:source]
  end

  def update_archival_series_fields ead_id, pid
    args = args_for_archival_series(ead_id,pid)
    self.archival_series = args[:name]
    self.archival_series_uri = args[:ref]
    self.archival_series_authority = args[:source]
  end

  def add_new_archival_series ead_id, pid
    self.new_archival_series(args_for_archival_series(ead_id,pid)) if self.archival_series.nil?
  end

  def args_for_collection pid
    {
      :name   => Artk::Resource.find_by_ead_id(pid).findingAidTitle,
      :ref    => "http://repository.rockhall.org/collections/"+pid,
      :source => "Rock and Roll Hall of Fame and Museum"
    }
  end

  def args_for_archival_series ead_id, pid
    {
      :name   => Artk::Resource.find_by_ead_id(ead_id).component(pid).title,
      :ref    => "http://repository.rockhall.org/collections/"+ead_id+"/components/"+pid,
      :source => "Rock and Roll Hall of Fame and Museum"
    }
  end

end
