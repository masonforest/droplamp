class IsKISSr
  def matches?(request)
    ("kissr.local" "www.kissr.co" "kisser.co").include?(request.host)
  end
end


Kissr::Application.routes.draw do
# If we are on the kissr domain  
  constraints(IsKISSr.new) do
    resources :pages
    resource :dropbox, :controller => 'dropbox' do
     get 'connect'
   end
   resources :sites
   root :to =>'pages#home'
   end
  resource :contact, :only => "create"
  resources :profiles
  match ":path" => "sites#show", :constraints => {:path => /.*/}  
end
