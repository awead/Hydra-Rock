require 'artk'

module Rockhall::Models::Collections
  extend ActiveSupport::Concern

  def update_collection params
    if self.collection.nil?
      self.new_collection(args_for_collection(params[:collection]))
      add_new_archival_series(params[:collection],params[:archival_series]) unless params[:archival_series].empty?
    elsif params[:collection].empty?
      self.delete_collection
      self.delete_archival_series unless self.archival_series.nil?
    else
      update_collection_fields params[:collection] 
      update_archival_series params
    end
  end

  def update_archival_series params
    if self.archival_series.nil?
      add_new_archival_series(params[:collection],params[:archival_series]) unless params[:archival_series].empty?
    elsif params[:archival_series].empty? 
      self.delete_archival_series unless self.archival_series.nil?
    else
      update_archival_series_fields params[:collection], params[:archival_series]
    end
  end

  protected

  def update_collection_fields ead_id
    args = args_for_collection(ead_id)
    self.collection = args[:name]
    self.collection_uri = args[:ref]
    self.collection_authority = args[:source]
  end

  def update_archival_series_fields ead_id, pid
    args = args_for_archival_series(ead_id,pid)
    self.archival_series = args[:name]
    self.archival_series_uri = args[:ref]
    self.archival_series_authority = args[:source]
  end

  def add_new_archival_series ead_id, pid
    self.new_archival_series(args_for_archival_series(ead_id,pid)) if self.archival_series.nil?
  end

  def args_for_collection pid
    {
      :name   => Artk::Resource.find_by_ead_id(pid).findingAidTitle,
      :ref    => "http://repository.rockhall.org/collections/"+pid,
      :source => "Rock and Roll Hall of Fame and Museum"
    }
  end

  def args_for_archival_series ead_id, pid
    {
      :name   => Artk::Resource.find_by_ead_id(ead_id).component(pid).title,
      :ref    => "http://repository.rockhall.org/collections/"+ead_id+"/components/"+pid,
      :source => "Rock and Roll Hall of Fame and Museum"
    }
  end

end