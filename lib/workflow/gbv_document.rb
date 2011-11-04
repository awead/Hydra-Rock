module Workflow
class GbvDocument < ActiveFedora::NokogiriDatastream

  include Rockhall::WorkflowMethods

  set_terminology do |t|
    t.root(:path=>"FMPXMLRESULT", :xmlns=>"http://www.filemaker.com/fmpxmlresult")

    t.resultset(:path=>"RESULTSET") {
      t.row(:path=>"ROW") {
        t.col(:path=>"COL")
      }
    }

    t.data(:ref=>[:resultset, :row, :col])

  end

  def respond(value)
    unless value.empty?
      return value
    end
  end

  # Fields from xml file, listed by column id

  # A
  def barcode
    unless self.data[0].match(/^3[0-9]+$/).nil?
      return self.data[0]
    end
  end

  # B
  def title
    return respond(self.data[1])
  end

  # C
  def orig_date
    return parse_date(self.data[2])
  end

  # E
  def condition
    return respond(self.data[4])
  end

  # F
  def format
    return respond(self.data[5])
  end

  # G
  def cleaning
    return respond(self.data[6])
  end

  # I
  def p_create_date
    return parse_date(self.data[8])
  end

  # J
  def p_extension
    return respond(self.data[9])
  end

  # N
  def p_codec
    return respond(self.data[13])
  end

  # AG
  def device
    return respond(self.data[32])
  end

  # AH
  def capture_soft
    return respond(self.data[33])
  end

  # AJ
  def p_operator
    return respond(self.data[35])
  end

  # AM
  def a_create_date
    return parse_date(self.data[38])
  end

  # AN
  def a_extension
    return respond(self.data[39])
  end

  # BA
  def a_codec
    return respond(self.data[52])
  end

  # BG
  def a_audio_bit_depth
    return respond(self.data[58])
  end

  # BK
  def trans_soft
    return respond(self.data[62])
  end

  # BL
  def trans_note
    return respond(self.data[63])
  end

  # BM
  def a_operator
    return respond(self.data[64])
  end

end
end