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

  def barcode
    unless self.data[0].match(/^3[0-9]+$/).nil?
      return self.data[0]
    end
  end

  def title
    unless self.data[1].empty?
      return self.data[1]
    end
  end

  def orig_date
    unless self.data[2].empty?
      return parse_date(self.data[2])
    end
  end

  def standard
    unless self.data[3].empty?
      return self.data[3]
    end
  end

  def condition
    unless self.data[4].empty?
      return self.data[4]
    end
  end

  def format
    unless self.data[5].empty?
      return self.data[5]
    end
  end

  def cleaning
    unless self.data[6].empty?
      return self.data[6]
    end
  end

  def create_date
    unless self.data[8].empty?
      return parse_date(self.data[8])
    end
  end

end
end