class ApplicationController < ActionController::Base
  
  include Blacklight::Controller
  include Hydra::Controller::ControllerBehavior
  include PublicActivity::StoreController

  layout 'hydra-head'

  protect_from_forgery

end
