HydraRock::Application.routes.draw do
  devise_for :installs

  Blacklight.add_routes(self)
  HydraHead.add_routes(self)

  root :to => "catalog#index"

  devise_for :users

  resources :nodes
  match ":controller/:id/:type(/:action(/:index))", :controller => /nodes/
  
  resources :archival_videos
  resources :digital_videos
  resources :external_videos
  resources :reviewers
  resources :permissions

  resources :archival_collections do
    resources :archival_components, :only => [:index]
  end

end
