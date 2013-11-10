Kissr::Application.routes.draw do
  mount Resque::Server, :at => "/resque"
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  devise_for :users do
    get "/users/sign_out" => "devise/sessions#destroy", :as => :destroy_user_session
  end
  


  get '/auth/:provider/callback' => 'sessions#create', as: 'omniauth_callback'
  resources :subscriptions
  resources :domains do
    get 'status', :on => :collection
  end
  resources :sites do
    post 'refresh', :on => :member
    get 'upgrade', :on => :member
  end
  
  root :to =>'pages#home', as: :home

  get "/signout" => "sessions#destroy", :as => :signout 
  get "/twenty-bucks-off/:user_id" => "refferals#create"
  get "/frequently-asked-questions" => 'high_voltage/pages#show', :id => 'frequently-asked-questions'
  get "/compare" =>'high_voltage/pages#show', :id => 'compare'
  get "/how-it-works" => 'high_voltage/pages#show', :id => 'how-it-works'
  get "/blog" => 'high_voltage/pages#show', :id => 'blog'

  resources :pages
end
