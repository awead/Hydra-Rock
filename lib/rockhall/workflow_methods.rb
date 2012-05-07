module Rockhall::WorkflowMethods

  def new_name(pid,file,opts={})
    elements = Array.new
    elements << pid.gsub(/:/,"_")
    elements << opts[:type]  unless opts[:type].nil?
    name = elements.join("_") + File.extname(file)
  end

  def move_content(src,dst,opts={})
    if File.exists?(dst)
      unless opts[:force]
        raise "Destination file exists"
      end
    end
    begin
      FileUtils.cp(src,dst)
    rescue Exception=>e
      raise "move_content for #{src} failed: #{e}"
    end
  end

  def get_file(path)
    if File.exists?(path)
      return File.split(path).last
    else
      return nil
    end
  end

  def parse_date(s)
    begin
      date = DateTime.parse(s)
    rescue
      return nil
    end
    return date.strftime("%Y-%m-%d")
  end

  def parse_ratio(r)
    if r.match(/^\d(.+)\d$/)
      return r.gsub(/ /,"").gsub(/[xX]/, ":")
    end
  end

  def parse_size(s)
    clean = s.strip
    if clean.match(/^\d(.+)\d$/)
      clean.gsub(/ /,"").downcase
    end
  end

  def parse_standard(t)
    terms = Hash.new
    terms = {
      "PCM"  => "Linear PCM Audio",
    }
    return nil if t.nil?
    if terms.include?(t)
      return terms[t]
    else
      return t
    end
  end

  def parse_encoding(t)
    terms = Hash.new
    terms = {
      "PCM"   => "Linear Pulse Code Modulation",
      "avc1"  => "H.264/MPEG-4 AVC",
      "MPEG4" => "MPEG-4: AAC"
    }
    return nil if t.nil?
    if terms.include?(t)
      return terms[t]
    else
      return t
    end
  end

  def get_next(index, length)
    last_index = length - 1
    next_index = index + 1
    if index == last_index
      return nil
    else
      return next_index
    end
  end

  def get_previous(index, length)
    unless index == 0
      previous = index - 1
    end
  end

  def get_model
    raise "No pid for #{self}" if self.pid.nil?
    af = ActiveFedora::Base.load_instance(self.pid)
    af.relationships(:has_model).first.split(":").last
  end

end

