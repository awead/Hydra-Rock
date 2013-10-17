class ArchivalCollectionsController < ApplicationController
  
  include Blacklight::Catalog
  include Rockhall::Controller::ControllerBehavior

  before_filter :authenticate_user!, :only=>[:create, :new, :update]
  before_filter :enforce_create_permissions, :only => [:new, :create]

  # Returns a json object of all the collection ids and names
  def index(results = Hash.new)
    ArchivalCollection.all.each do |coll|
      results[coll.pid] = coll.title
    end
    render :json=>results.to_json
  end

  def new
    @afdoc = ArchivalCollection.new
    respond_to do |format|
      format.html  # new.html.erb
      format.json  { render :json => @afdoc }
    end
  end

  def show
    redirect_to catalog_path(params[:id])
  end

  def create
    pid = params[:archival_collection]["pid"].downcase.gsub(/-/,":")
    @afdoc = ArchivalCollection.new(:pid=>pid)
    @afdoc.get_title_from_solr
    if @afdoc.errors.empty?
      @afdoc.save
      @afdoc.update_components
      redirect_to catalog_path(@afdoc)
    else
      flash[:alert] = @afdoc.errors.messages
      render :action => "new"
    end
  end

  def destroy
    coll = ArchivalCollection.find(params[:id])
    coll.delete_componets
    af.delete
    msg = "Deleted archival collection #{params[:id]}"
    flash[:notice]= msg
    redirect_to catalog_index_path()
  end

end