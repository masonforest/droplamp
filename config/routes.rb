class OmniauthPassThru
    def self.matches?(request)
        !request.fullpath.start_with?('/auth/') 
    end
end

class IsKISSr
  def self.matches?(request)
   
  end
end
Kissr::Application.routes.draw do

match "/auth/:provider/callback" => "sessions#create"


# If we are on the kissr domain  
  scope :constraints => lambda{|req| ("localhost" "kissr.local" "127.0.0.1" "kissr.co" "kissr" "www.kissr.co" "kissr-staging.herokuapp.com").include?(req.host) }  do
    resources :pages
    resources :domains do
     get 'status', :on => :collection
    end
    resources :sites
  
    root :to =>'pages#home'

    match '/auth/:provider/callback', :to => 'sessions#create'
    match "/signout" => "sessions#destroy", :as => :signout 
  end
scope :constraints => lambda{|req| not ("localhost" "kissr.local" "127.0.0.1" "kissr.co" "kissr").include?(req.host) } do
  resource :contact, :only => "create"
  match ":path" => "sites#show", :constraints=>lambda{|req| !req.fullpath.start_with?('/auth/')}
  root :to => "sites#show"
  match '/auth/:provider/callback', :to => 'sessions#create'
end
end
