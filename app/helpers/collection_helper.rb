module CollectionHelper

  def components_for_select 
    if @afdoc.collection_uri.nil?
      []
    else
      Artk::Resource.find_by_ead_id(@afdoc.ead_id).all_series.collect { |s| [s.title, s.persistentId] unless s.title.empty? }.compact
    end
  end
  
end