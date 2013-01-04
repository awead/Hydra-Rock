class NodesController < ApplicationController

  include Hydra::Controller::ControllerBehavior

  before_filter :authenticate_user!, :only=>[:create, :new, :edit, :update]
  before_filter :enforce_access_controls

  def new
  end

  def edit
  end

  def update
  end

  def create
    @object = ArchivalVideo.find(params[:archival_video_id])
    type = params[:node].keys.first

    if @object.respond_to?("new_"+type)
      @object.send("new_"+type, params[:node][type])
    else
      @object.errors["node"] = "#{type} is not defined"
    end

    if @object.errors.empty?
      @object.save
      respond_to do |format|
        format.html { redirect_to edit_archival_video_path(params[:archival_video_id]) }
        #format.js   { render :partial => "pbcore_nodes/edit/#{params[:node]}", :locals => {:document=>@afdoc} }
      end
    else
      flash[:notice] = "Unable to insert node: #{@object.errors.full_messages.join("<br/>")}"
      respond_to do |format|
        format.html { redirect_to edit_archival_video_path(params[:archival_video_id]) }
        #format.js
      end 
    end
  end

  def destroy
  end


end
