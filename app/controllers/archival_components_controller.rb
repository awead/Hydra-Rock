class ArchivalComponentsController < ApplicationController

  # Returns a json object of all the components for a given collection
  def index(results = Hash.new)
    coll = ArchivalCollection.load_instance_from_solr(params[:archival_collection_id])
    coll.series.each do |c|
      results[c.pid] = c.title
    end
    render :json=>results.to_json
  end

end