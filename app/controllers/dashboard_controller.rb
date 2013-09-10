require 'blacklight/catalog'
class DashboardController < ApplicationController
  include  Sufia::DashboardControllerBehavior

  protected
  def get_dashboard_results
    get_search_results(params, {:fq => 'has_model_ssim:"info:fedora/afmodel:GenericFile"'})
  end
end