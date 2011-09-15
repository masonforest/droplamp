RailsAdmin.config do |config|
  config.authenticate_with do |c|
    session[:redirect_to] ="/admin"
    puts  "aaav"+session[:redirect_to]
    c.authenticate_user
  end
  config.authorize_with do 
    puts current_user
    redirect_to '/' unless current_user.try(:admin?)
  end


end

