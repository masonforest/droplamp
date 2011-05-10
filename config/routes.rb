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

  root :to => "site#root"
  match ":id" => "site#page", :id => "[:id]" 
end
