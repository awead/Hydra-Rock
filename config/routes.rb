HydraRock::Application.routes.draw do
  Blacklight.add_routes(self)
  HydraHead.add_routes(self)

  root :to => "catalog#index"

  devise_for :users

  # Not sure if this is mine or a leftover from Hydrangea
  resources :generic_content_objects

  # My routes go here
  # Routes for subjects and pbcore controller
  resources :assets do
    resources :subjects, :only=>[:new,:create]
    resources :pbcore, :only=>[:new,:create]
    #resources :pbcore
  end

  #map.asset_subject 'assets/:asset_id/subjects/:subject_type/:index', :controller=>:subjects, :action=>:show, :conditions => { :method => :get }
  match "assets/:asset_id/subjects/:subject_type/:index" => "subjects#show", :as => :asset_subject, :via => :get

  #map.asset_pbcore 'assets/:asset_id/pbcore/:node/:index', :controller=>:pbcore, :action=>:show, :conditions => { :method => :get }
  match "assets/:asset_id/pbcore/:node/:index" => "pbcore#show", :as => :asset_pbcore, :via => :get

  #map.connect 'assets/:asset_id/subjects/:subject_type/:index', :controller=>:subjects, :action=>:destroy, :conditions => { :method => :delete }
  match "assets/:asset_id/subjects/:subject_type/:index" => "subjects#destroy", :via => :delete

  #map.connect 'assets/:asset_id/pbcore/:node/:index', :controller=>:pbcore, :action=>:destroy, :conditions => { :method => :delete }
  match "assets/:asset_id/pbcore/:node/:index" => "pbcore#destroy", :via => :delete

  # end of my routes



  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end


  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
