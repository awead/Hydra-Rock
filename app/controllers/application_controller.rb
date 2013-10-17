class ApplicationController < ActionController::Base
  
  include Blacklight::Controller
  include Hydra::Controller::ControllerBehavior
  include PublicActivity::StoreController

  layout 'hydra-head'

  protect_from_forgery

  unless Rails.env.match("development")
    rescue_from ActionView::Template::Error,           :with => :render_500
    rescue_from ActiveRecord::StatementInvalid,        :with => :render_500
    rescue_from RSolr::Error::Http,                    :with => :render_500
    rescue_from Rubydora::FedoraInvalidRequest,        :with => :render_500
    rescue_from AbstractController::ActionNotFound,    :with => :render_404
    rescue_from ActiveRecord::RecordNotFound,          :with => :render_404
    rescue_from Blacklight::Exceptions::InvalidSolrID, :with => :render_404
  end

  def render_500
    flash[:alert] = "An error has occurred"
    redirect_to root_path
  end

  def render_404
    flash[:alert] = "The page was not found"
    redirect_to root_path
  end

  # override Devise to allow additional attributes
  before_filter :configure_permitted_parameters, :if => :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end

end
