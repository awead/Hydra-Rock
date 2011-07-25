class ApplicationController < ActionController::Base
  # Adds Hydra behaviors into the application controller 
   include Hydra::Controller
  # Adds a few additional behaviors into the application controller 
   include Blacklight::Controller
  # Please be sure to impelement current_user and user_session. Blacklight depends on 
  # these methods in order to perform user specific actions. 

  protect_from_forgery
end
