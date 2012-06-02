class PbcoreNodesController < ApplicationController

  respond_to :html, :js

  def new
    af_model = retrieve_af_model(params[:content_type], :default=>ArchivalVideo)
    @document_fedora = af_model.find(params[:id])
    node, index = @document_fedora.insert_node(params[:node])

    if @document_fedora.save
      respond_to do |format|
        format.html { redirect_to edit_archival_video_path(params) }
        format.js   { render :partial => "pbcore_nodes/edit/#{params[:node]}", :locals => {:document=>@document_fedora} }
      end
    else
      flash[:notice] = "Unable to insert node: #{@document_fedora.errors.inspect}"
      respond_to do |format|
        format.html { redirect_to edit_archival_video_path(params) }
        format.js
      end
    end
  end

  def destroy
    af_model = retrieve_af_model(params[:content_type], :default=>ArchivalVideo)
    @document_fedora = af_model.find(params[:id])
    @document_fedora.remove_node(params[:node],params[:index])

    if @document_fedora.save
      respond_to do |format|
        format.html { redirect_to edit_archival_video_path(params) }
        format.js   { render :partial => "pbcore_nodes/edit/#{params[:node]}", :locals => {:document=>@document_fedora} }
      end
    else
      flash[:notice] = "Unable to delete node: #{@document_fedora.errors.inspect}"
      respond_to do |format|
        format.html { redirect_to edit_archival_video_path(params) }
        format.js
      end
    end
  end

end