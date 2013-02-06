# Searches each pid in Fedora and finds datasteams with controlGroup "M"
# and converts them to "X"
#
# All versions of the of the datastreams will be lost in the conversion.
#
# This is designed to be run in the console. Ex:
#
# > job = Rockhall::DatastreamConversion.new
# > job.range = (1..9)
# > job.convert_range
#   rrhof:1 => not found
#   rrhof:2 => not found
#   rrhof:3 => not found
#   rrhof:4 => not found
#   rrhof:5 => descMetadata, unchanged; properties, unchanged; assetReview, unchanged; mediaInfo, unchanged;
#   rrhof:6 => descMetadata, unchanged; properties, unchanged; assetReview, unchanged; mediaInfo, unchanged;
#   rrhof:7 => not found
#   rrhof:8 => not found
#   rrhof:9 => not found

class Rockhall::DatastreamConversion

  attr_accessor :range

  # Uses a numeric range with a hard-coded pid prefix to look through all your Fedora objects
  def convert_range
    self.range.each do |id|
      pid = "rrhof:" + id.to_s
      print pid + " => "
      begin
        obj = ActiveFedora::Base.find(pid, :cast => true)
        results = convert obj
        report results
      rescue
        puts "not found"
      end
    end
  end

  def convert obj

    dsList = {
      "descMetadata" => "unchanged",
      "properties"   => "unchanged",
      "assetReview"  => "unchanged",
      "mediaInfo"    => "unchanged",
    }
    
    dsList.keys.each do |ds|      
      unless obj.datastreams[ds].nil?
        if obj.datastreams[ds].controlGroup == "M"
          replace_datastream obj, ds
          dsList[ds] = "converted"
        end
      end
    end

    return dsList
  end

  def replace_datastream obj, ds_name
    xml = obj.datastreams[ds_name].ng_xml
    obj.datastreams[ds_name].delete
    obj.save
    reload = ActiveFedora::Base.find(obj.pid, :cast => true)
    reload.datastreams[ds_name].ng_xml = xml
    reload.save
  end

  def report results
    a = Array.new
    results.keys.each do |ds|
      a << (ds.to_s + ", " + results[ds].to_s + ";")
    end
    puts a.join(" ")
  end


end