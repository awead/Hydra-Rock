# -*- coding: utf-8 -*-
class GenericFilesController < ApplicationController
  include Sufia::Controller
  include Sufia::FilesControllerBehavior

  layout 'hydra-rock'

  def show
    redirect_to catalog_path(params[:id])
  end

  def index
    redirect_to catalog_index_path
  end
end