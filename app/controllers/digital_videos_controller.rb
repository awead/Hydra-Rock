class DigitalVideosController < ApplicationController
  
  include Blacklight::Catalog

  before_filter :deprecation_redirect, :except => [:show]

  def show
    redirect_to catalog_path(params[:id])
  end
  
  def deprecation_redirect
    flash[:alert] = "Digital video model is deprecated"
    redirect_to root_path
  end

end