Kissr::Application.routes.draw do

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  devise_for :users do
    get "/users/sign_out" => "devise/sessions#destroy", :as => :destroy_user_session
  end
  


  match '/auth/:provider/callback' => 'sessions#create'
  resources :pages
  resources :domains do
    get 'status', :on => :collection
  end
  resources :sites do
    get 'activate', :on => :member
  end
  
  root :to =>'application#index'

  match "/signout" => "sessions#destroy", :as => :signout 

end
