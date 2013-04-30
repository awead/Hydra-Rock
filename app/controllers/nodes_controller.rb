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
    @object = ActiveFedora::Base.find(params[:id], :cast => true)
    if params[:type]
      render :partial => "nodes/edit/#{params[:type]}", :locals => {:document=>@object}
    else
      flash[:notice] = "Node type is required"
      redirect_to root_path
    end
  end

  def create
    @object = ActiveFedora::Base.find(params[:id], :cast => true)
    @object.create_node(params)
    if @object.errors.empty?
      @object.save
      flash[:notice] = "Added #{params.inspect}"
    else
      flash[:notice] = "Unable to insert node: #{@object.errors.full_messages.join("<br/>")}"
    end

    respond_to do |format|
      format.html { redirect_to edit_node_path(@object.id, params[:type]) }
      format.js   { render :partial => "nodes/new/#{params[:type]}" }
    end 
  end

  def destroy
    @object = ActiveFedora::Base.find(params[:id], :cast => true)
    result = @object.send("delete_"+params[:type], params[:index])
    @object.save unless result.nil?

    respond_to do |format|
      format.html { redirect_to edit_node_path(params[:id], params[:type]) }
      format.js   { render :partial => "nodes/new/#{params[:type]}" }
    end 
  end

end
