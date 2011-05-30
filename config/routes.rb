ActionController::Routing::Routes.draw do |map|
  map.resources :comments, :collection => {:ajax_create => :post}
  map.resources :mocks
  map.resources :mock_lists
  map.resources :projects, :member => {:mock_list_selector => :get}
  map.logout '/session/destroy', :controller => :sessions, :action => :destroy
  map.resource  :session
  map.resources :settings,
    :collection => {
      :campfire => :get, :email => :get,
      :update_campfire => :put, :users => :get
    }
  map.resources :users
  map.resources :home, :collection => {:mock_set => :get}
  map.claim '/claim', :controller => :claim

  map.home '', :controller => 'home', :actions => 'index'
  map.usage '/usage', :controller => 'usage'
  map.root :controller => 'home', :actions => 'index'
end
