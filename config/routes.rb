HydraRock::Application.routes.draw do
  devise_for :installs

  Blacklight.add_routes(self)
  HydraHead.add_routes(self)

  root :to => "catalog#index"

  devise_for :users
  resources :users
  resources :activities

  resources :nodes
  match ":controller/:id/:type(/:action(/:index))", :controller => /nodes/
  
  resources :archival_videos
  resources :digital_videos
  resources :external_videos, :except => [:new, :create]
  # Fake a nested route for new and create actions on external videos
  match "archival_videos/:archival_video_id/external_videos/new" => "external_videos#new"
  match "archival_videos/:archival_video_id/external_videos"     => "external_videos#create"
  resources :reviewers
  resources :permissions

  resources :archival_collections do
    resources :archival_components, :only => [:index]
  end

end
