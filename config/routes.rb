HydraRock::Application.routes.draw do
  devise_for :installs

  Blacklight.add_routes(self)
  HydraHead.add_routes(self)

  root :to => "catalog#index"

  devise_for :users
  resources :users, :only => [:index, :show]
  resources :activities, :only => [:index]

  resources :nodes, :only => [:edit, :create, :new, :destroy] do
    member do
      get    ':type/edit',   :action => 'edit',   :as => 'edit'
      get    ':type/new',    :action => 'new',    :as => 'new'
      post   ':type/create', :action => 'create', :as => 'create'
    end
  end
  match ":controller/:id/:type(/:action(/:index))", :controller => /nodes/
  
  
  resources :archival_videos do
    member do
      put 'assign'
      get 'import'
      put 'transfer'
      get 'edit/:wf_step', :action => 'edit', :as => 'workflow'
    end
    # Used nested resources for only creating new external videos
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
