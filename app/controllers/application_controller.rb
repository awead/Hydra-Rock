class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller 
   include Blacklight::Controller  
# Adds Hydra behaviors into the application controller 
  include Hydra::Controller
  def layout_name
   'hydra-head'
  end

  # Please be sure to impelement current_user and user_session. Blacklight depends on 
  # these methods in order to perform user specific actions. 


  # Adds Hydra behaviors into the application controller
   include Hydra::Controller
  # Adds a few additional behaviors into the application controller
   include Blacklight::Controller  
# Adds Hydra behaviors into the application controller 
  include Hydra::Controller
  def layout_name
   'hydra-head'
  end


  def layout_name
   'hydra-head'
  end

  # Please be sure to impelement current_user and user_session. Blacklight depends on
  # these methods in order to perform user specific actions.

  before_filter :add_local_assets

  protect_from_forgery

  protected

  def add_local_assets
    stylesheet_links << [ "rockhall", "video-js/video-js.css" ]
    javascript_includes << [ "rockhall/rockhall.js", "video-js/video.js" ]
  end

end
