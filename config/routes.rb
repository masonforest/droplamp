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
    get 'upgrade', :on => :member
  end
  
  root :to =>'pages#home'

  match "/signout" => "sessions#destroy", :as => :signout 
  match "/twenty-bucks-off/:user_id" => "refferals#create"
  match "/frequently-asked-questions" => 'high_voltage/pages#show', :id => 'frequently-asked-questions'
  match "/compare" =>'high_voltage/pages#show', :id => 'compare'
  match "/how-it-works" => 'high_voltage/pages#show', :id => 'how-it-works'
  match "/blog" => 'high_voltage/pages#show', :id => 'blog'

end
