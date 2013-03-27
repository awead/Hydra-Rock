module CollectionHelper

  def collection_components(pid, opts={},results = Array.new)
    begin
      coll = ArchivalCollection.load_instance_from_solr(pid)
    rescue
      return []
    end
    coll.component.each do |comp|
      results << comp unless comp.item.empty? and opts[:all].nil?
    end
    return results
  end

  def collection_items(pid, results = Array.new)
    coll = ArchivalCollection.load_instance_from_solr(pid)
    coll.item.each do |item|
      results << link_to(item.main_title, catalog_path(item.pid))
    end
    return results
  end

  def component_items(component, results = Array.new)
    component.item.each do |item|
      results << link_to(item.main_title, catalog_path(item.pid))
    end
    return results
  end

end