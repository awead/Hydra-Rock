class ArchivalCollectionsController < ApplicationController
  
  include Blacklight::Catalog
  include Hydra::Controller::ControllerBehavior
  include Rockhall::Controller::ControllerBehavior

  before_filter :authenticate_user!, :only=>[:create, :new, :update]
  before_filter :enforce_access_controls
  before_filter :enforce_asset_creation_restrictions, :only=>:new

  # Returns a json object of all the collection ids and names
  def index(results = Hash.new)
    ArchivalCollection.find(:all).each do |coll|
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
    update_session
    session[:viewing_context] = "browse"
    @afdoc = ArchivalCollection.find(params[:id])
    respond_to do |format|
      format.html  { setup_next_and_previous_documents }
      format.json  { render :json => @afdoc }
    end
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
    coll = ArchivalCollection.find(params[:id], :cast=>true)
    coll.delete_componets
    af.delete
    msg = "Deleted archival collection #{params[:id]}"
    flash[:notice]= msg
    redirect_to catalog_index_path()
  end

end