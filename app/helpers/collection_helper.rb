module CollectionHelper

  def components_for_collection_id id
    ArchivalCollection.load_instance_from_solr(id).series
  end

  def components_for_collection
    @afdoc.collection.nil? ? [] : @afdoc.collection.series.collect { |s| [s.title, s.pid] }
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