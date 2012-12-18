class ApplicationController < ActionController::Base
  include Blacklight::Controller
  include Hydra::Controller::ControllerBehavior

  layout 'hydra-head'

  protect_from_forgery

end
