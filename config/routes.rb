Kissr::Application.routes.draw do
  devise_for :users

  mount Resque::Server, :at => "/resque"
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  devise_for :users do
    get "/users/sign_out" => "devise/sessions#destroy", :as => :destroy_user_session
  end
  


  match '/auth/:provider/callback' => 'sessions#create'
  resources :pages
  resources :subscriptions
  resources :domains do
    get 'status', :on => :collection
  end
  resources :sites do
    post 'refresh', :on => :member
  end
  
  root :to =>'pages#home'

  match "/signout" => "sessions#destroy", :as => :signout 
  match "/fivebucksoff/:user_id" => "refferals#create"

end
