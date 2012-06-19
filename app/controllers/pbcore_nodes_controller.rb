class PbcoreNodesController < ApplicationController

  respond_to :html, :js

  def new
    af_model = retrieve_af_model(params[:content_type], :default=>ArchivalVideo)
    @afdoc = af_model.find(params[:id])
    node, index = @afdoc.insert_node(params[:node])

    if @afdoc.save
      respond_to do |format|
        format.html { redirect_to edit_archival_video_path(params) }
        format.js   { render :partial => "pbcore_nodes/edit/#{params[:node]}", :locals => {:document=>@afdoc} }
      end
    else
      flash[:notice] = "Unable to insert node: #{@afdoc.errors.inspect}"
      respond_to do |format|
        format.html { redirect_to edit_archival_video_path(params) }
        format.js
      end
    end
  end

  def destroy
    af_model = retrieve_af_model(params[:content_type], :default=>ArchivalVideo)
    @afdoc = af_model.find(params[:id])
    @afdoc.remove_node(params[:node],params[:index])

    if @afdoc.save
      respond_to do |format|
        format.html { redirect_to edit_archival_video_path(params) }
        format.js   { render :partial => "pbcore_nodes/edit/#{params[:node]}", :locals => {:document=>@afdoc} }
      end
    else
      flash[:notice] = "Unable to delete node: #{@afdoc.errors.inspect}"
      respond_to do |format|
        format.html { redirect_to edit_archival_video_path(params) }
        format.js
      end
    end
  end

end