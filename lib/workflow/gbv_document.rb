module Workflow
class GbvDocument < ActiveFedora::NokogiriDatastream

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
    return self.data[1]
  end

end
end