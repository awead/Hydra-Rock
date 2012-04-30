HydraRock::Application.routes.draw do
  Blacklight.add_routes(self)
  HydraHead.add_routes(self)

  root :to => "catalog#index"

  devise_for :users

  # Not sure if this is mine or a leftover from Hydrangea
  #resources :generic_content_objects

  # My routes go here
  # Routes for subjects and pbcore controller
  namespace :hydra do
    resources :assets do
      resources :subjects, :only=>[:new,:create]
      resources :pbcore, :only=>[:new,:create]
    end
  end

  match "hydra/assets/:asset_id/subjects/:subject_type/:index" => "subjects#show", :as => :asset_subject, :via => :get
  match "hydra/assets/:asset_id/pbcore/:node/:index" => "pbcore#show", :as => :asset_pbcore, :via => :get
  match "hydra/assets/:asset_id/subjects/:subject_type/:index" => "subjects#destroy", :via => :delete
  match "hydra/assets/:asset_id/pbcore/:node/:index" => "pbcore#destroy", :via => :delete
  resources :reviewers, :only=>[:edit, :update, :show]

  # end of my routes

end
