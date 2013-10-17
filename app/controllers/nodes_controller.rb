class NodesController < ApplicationController

  include Rockhall::Controller::ControllerBehavior

  before_filter :authenticate_user!, :only=>[:create, :new, :edit, :update]

  def new
    if params[:type]
      respond_to do |format|
        format.html { render :partial => "nodes/new/#{params[:type]}" if request.xhr? }
      end
    else
      flash[:notice] = "Node type is required"
      redirect_to root_path
    end
  end

  def edit
    @object = ActiveFedora::Base.find(params[:id], :cast => true)
    if params[:type]
      respond_to do |format|
        format.html { render :partial => "nodes/edit/#{params[:type]}", :locals => {:document=>@object} if request.xhr? }
     end
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
      flash[:notice] = "Video was updated successfully"
    else
      flash[:notice] = "Unable to insert node: #{@object.errors.full_messages.join("<br/>")}"
    end

    respond_to do |format|
      format.html { 
        if request.xhr?
          render :partial => "nodes/new/#{params[:type]}"
        else
          redirect_to edit_node_path
        end
      }
    end 
  end

  def destroy
    @object = ActiveFedora::Base.find(params[:id], :cast => true)
    @object.save if @object.send("delete_"+params[:type], params[:index])

    type = params[:type].match(/event/) ? "event" : params[:type]
    respond_to do |format|
      format.html { redirect_to edit_node_path(params[:id], type) }
      format.js   { render :partial => "nodes/edit/#{type}", :locals => {:document=>@object} }
    end 
  end

end
