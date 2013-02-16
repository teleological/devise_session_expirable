
Rails.application.routes.draw do

  resources :users, :only => [:index] do
    get :expire, :on => :member
    get :clear_timeout, :on => :member
  end

  resources :admins, :only => [:index] do
    get :expire, :on => :member
  end

  devise_for :users

  get "/sign_in", :to => "devise/sessions#new"

  devise_for :admin, :path => "admin_area",
    :controllers => { :sessions => :"admins/sessions" },
    :skip => :passwords

  get "/anywhere", :to => "foo#bar", :as => :new_admin_password

  root :to => "home#index"

end

