class ApplicationController < ActionController::Base

  include Blacklight::Controller
  include Hydra::Controller::ControllerBehavior

  def layout_name
   'hydra-head'
  end

  protect_from_forgery

end
