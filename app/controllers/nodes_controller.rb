class NodesController < ApplicationController

  include Hydra::Controller::ControllerBehavior
  include Rockhall::Controller::ControllerBehavior

  before_filter :authenticate_user!, :only=>[:create, :new, :edit, :update]
  before_filter :enforce_access_controls

  def new
    if params[:type]
      render :partial => "nodes/new/#{params[:type]}"
    else
      flash[:notice] = "Node type is required"
      redirect_to root_path
    end
  end

  def edit
  end

  def update
  end

  def create
    @object = get_model_from_pid(params[:id])
    @object.create_node(params)
    @object.errors.empty? ? @object.save : flash[:notice] = "Unable to insert node: #{@object.errors.full_messages.join("<br/>")}"

    respond_to do |format|
      format.html { redirect_to send(("edit_"+@object.class.to_s.underscore+"_path"), @object.pid) }
      #format.js
    end 
  end

  def destroy
  end

end
