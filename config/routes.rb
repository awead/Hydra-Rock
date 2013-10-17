HydraRock::Application.routes.draw do

  devise_for :users
  Blacklight.add_routes(self)
  HydraHead.add_routes(self)

  mount Artk::Engine => '/artk'

  root :to => 'catalog#index'
  
  resources :users, :only => [:index, :show]
  resources :activities, :only => [:index]

  # Special routes for nodes.  These are probably better done as a resource, but
  # this will work for now.
  #
  # Routes for actual controller methods
  match 'nodes/:id/:type/edit'   => 'nodes#edit',     :via => :get, :as => "edit_node" 
  match 'nodes/:id/:type/new'    => 'nodes#new',      :via => :get, :as => "new_node"
  match 'nodes/:id/:type'        => 'nodes#create',   :via => :post
  match 'nodes/:id/:type/:index' => 'nodes#destroy',  :via => :delete

  # Bogus route to #show, only so we can have a node_path method in our views
  match 'nodes/:id/:type(/:index)' => 'nodes#show',   :via => :get, :as => "node" 
  
  resources :archival_videos do
    member do
      patch 'assign'
      get   'import'
      post  'transfer'
      get   'edit/:wf_step', :action => 'edit', :as => 'workflow'
    end
    # Used nested resources for only creating new external videos
    resources :external_videos, :only => [:new, :create, :index]
  end
  resources :external_videos, :except => [:new, :create, :index]

  resources :digital_videos
  
  resources :permissions

  resources :archival_collections do
    resources :archival_components, :only => [:index]
  end

  resources :headings, :only => [:index] do
    collection do
      get ':term', :action => 'index'
    end
  end

  # In production, grab anything else and redirect to the catalog page
  match '*a', :to => 'catalog#index', via: [:get, :post] if Rails.env.match("production")

end
