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

  def get_checksum(sum)
    if get_file(sum).nil?
      return nil
    else
      return File.new(sum, "r").gets.split(/ /).first
    end
  end


  def prep_content(sip)
    raise "Invalid SIP" unless sip.valid?

    move_content(sip.root, sip.preservation, Blacklight.config[:video][:preservation_location] )
    move_content(sip.root, sip.access_hq, Blacklight.config[:video][:access_location] )
    move_content(sip.root, sip.access_lq, Blacklight.config[:video][:access_location] )

    if self.status == "ok"
      sip.status = "ready"
      sip.store
    else
      sip.status = self.status
      sip.store
    end
    return self.status
  end

  def move_content_without_checksum(root, name, dst)
    src = File.join(root, name)
    begin
      cp(src, dst)
      md5 = Digest::MD5.file(src)
      out = File.new(File.join(dst, (name + ".md5").to_s), "w")
      result = md5.to_s + "  " + name
      out.write result
      out.close
      self.status = "ok"
    rescue Exception=>e
      self.status ="move_content failed: #{e}"
    end
  end

  def move_content_with_checksum(root, name, dst)


  end


end

