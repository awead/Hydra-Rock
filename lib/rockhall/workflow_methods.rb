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

  # Assumes American-style date format:
  # mm/dd/year where year is either 2 or 4 digits
  def parse_date(s)
    begin
      if s =~ /^(\d{1,2})\/(\d{1,2})\/([2-9]{1}\d{1})$/
        date = DateTime.parse("#{$2}/#{$1}/19#{$3}")
      elsif s =~ /^(\d{1,2})\/(\d{1,2})\/([0-1]{1}\d{1})$/
        date = DateTime.parse("#{$2}/#{$1}/20#{$3}")
      elsif s =~ /^(\d{1,2})\/(\d{1,2})\/(\d{4})$/
        date = DateTime.parse("#{$2}/#{$1}/#{$3}")
      elsif s =~ /^(\d\d\d\d)-(\d\d)$/
        if (1...13).include?($2.to_i) and (1000...3000).include?($1.to_i)
          return s
        else
          return nil
        end
      elsif s =~ /^(\d\d\d\d)$/
        if (1000...3000).include?($1.to_i)
          return s
        else
          return nil
        end
      else
        date = DateTime.parse(s)
      end
    rescue
      return nil
    end
    return date.strftime("%Y-%m-%d")
  end

  # Returns the 4-digit year from a string
  def get_year(s)
    begin
      return DateTime.parse(s).year.to_s
    rescue
      if s.match(/^\d\d\d\d$/)
        return s.to_s
      elsif s.match(/^(\d\d\d\d)-\d\d$/)
        return $1.to_s
      else
        return nil
      end
    end
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

  def parse_empty(t)
    if t.empty?
      return nil
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

  # Creates a thumbnail for your video using ffmpegthumbnailer
  #   http://code.google.com/p/ffmpegthumbnailer 
  # Saves the file to /tmp/thumb.jpg
  def generate_video_thumbnail file
    FileUtils.rm("tmp/thumb.jpg") if File.exists?("tmp/thumb.jpg")
    `ffmpegthumbnailer -i #{file} -o tmp/thumb.jpg`
  end

end

