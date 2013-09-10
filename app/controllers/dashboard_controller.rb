require 'blacklight/catalog'
class DashboardController < ApplicationController
  include  Sufia::DashboardControllerBehavior

  # override to only include GenericFile objects in the dashboard
  def exclude_unwanted_models solr_parameters, user_parameters
    solr_parameters[:fq] ||= []
    solr_parameters[:fq] << "#{Solrizer.solr_name("has_model", :symbol)}:\"info:fedora/afmodel:GenericFile\""
  end
end