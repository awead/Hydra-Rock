HydraRock::Application.routes.draw do
  devise_for :installs

  Blacklight.add_routes(self)
  HydraHead.add_routes(self)

  root :to => "catalog#index"

  devise_for :users

  resources :archival_videos
  resources :digital_videos
  resources :external_videos
  resources :pbcore_nodes, :only => [:new , :destroy]
  resources :reviewers, :only => [:edit, :show]
  resources :permissions

end
