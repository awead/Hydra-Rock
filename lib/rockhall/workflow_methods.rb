module Rockhall::WorkflowMethods

  attr_accessor :status

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

  def move_content(root, name, dst)
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

end

