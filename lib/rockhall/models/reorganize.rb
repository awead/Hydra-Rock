module Rockhall::Models::Reorganize
  extend ActiveSupport::Concern

  def capture_collections
    self.properties.additional_collection = self.additional_collection unless additional_collection_saved?
    self.properties.collection_title = self.collection.title           unless collections_saved?
    self.properties.series = self.series.title                         unless series_saved?
  end

  def collections_saved?
    (collection_saved? && series_saved? && additional_collection_saved?) ? true : false
  end

  def remove_collections
    self.collection = nil
    self.series = nil
    self.additional_collection.each_index.collect { |i| self.delete_collection(i) }
  end

  private

  def collection_saved?
    if self.collection.nil?
      return true
    else
      self.collection.title == self.properties.collection_title.first ? true : false
    end
  end

  def series_saved?
    if self.series.nil?
      return true
    else
      self.series.title == self.properties.series.first ? true : false
    end
  end

  # hacky way of comparing arrays
  def additional_collection_saved?
    if self.additional_collection.empty?
      return true
    else
      self.additional_collection.join("#") == self.properties.additional_collection.join("#") ? true : false
    end
  end

end