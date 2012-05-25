HydraRock::Application.routes.draw do
  Blacklight.add_routes(self)
  HydraHead.add_routes(self)

  root :to => "catalog#index"

  devise_for :users

  resources :archival_videos
  resources :digital_videos
end
