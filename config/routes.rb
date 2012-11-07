Licenses::Application.routes.draw do
  
  get "dashboard/index"

  devise_for :users

  resources :users
  resources :distributors
  resources :applications
  resources :clients do
    resources :computers, :only => [ :edit, :update, :new, :create ]
  end
  resources :licenses do
    get 'update_computers', :on => :collection
    get 'remove', :on => :member
  end
  resources :process, :only => :index do
    put "update", :on => :collection
  end
  resources :transfers, :only => :update do
    get "new", :on => :member
  end

  root :to => 'dashboard#index'

end
