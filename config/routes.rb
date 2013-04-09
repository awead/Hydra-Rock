HydraRock::Application.routes.draw do
  devise_for :installs

  Blacklight.add_routes(self)
  HydraHead.add_routes(self)

  root :to => "catalog#index"

  devise_for :users
  resources :users, :only => [:index, :show]
  resources :activities, :only => [:index]

  resources :nodes
  match ":controller/:id/:type(/:action(/:index))", :controller => /nodes/
  
  # Used nested resources for only creating new external videos
  resources :archival_videos do
    resources :external_videos, :only => [:new, :create]
  end
  resources :external_videos, :except => [:new, :create]

  resources :digital_videos
  
  resources :reviewers
  resources :permissions

  resources :archival_collections do
    resources :archival_components, :only => [:index]
  end

end
