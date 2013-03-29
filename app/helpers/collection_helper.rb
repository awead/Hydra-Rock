module CollectionHelper

  def collection_components(pid, opts={},results = Array.new)
    begin
      coll = ArchivalCollection.load_instance_from_solr(pid)
    rescue
      return []
    end
    coll.series.each do |comp|
      results << comp unless comp.videos.empty? and opts[:all].nil?
    end
    return results
  end

  def collection_items(pid, results = Array.new)
    coll = ArchivalCollection.load_instance_from_solr(pid)
    coll.videos.each do |item|
      results << link_to(item.title, catalog_path(item.pid))
    end
    return results
  end

  def component_items(component, results = Array.new)
    component.videos.each do |item|
      results << link_to(item.title, catalog_path(item.pid))
    end
    return results
  end

end