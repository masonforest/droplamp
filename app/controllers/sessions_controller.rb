class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    logger.debug auth
    user = User.where(:provider => auth['provider'], 
                      :uid => auth['uid'].to_s).first|| User.create_with_omniauth(auth)
    session[:user_id]=user.id
    
    if session[:site]
      puts "creating #{ActiveSupport::JSON.decode(session[:site]).merge( owner: user)}"
      @site = Site.create(ActiveSupport::JSON.decode(session[:site]).merge( owner: user))
    end
    
    redirect_to sites_path, :notice => 'Signed in!'
  end
 def failure
    redirect_to root_url, :alert => "Authentication error: #{params[:message].humanize}"
  end
 def new
    redirect_to "/auth/#{config['provider']}"
  end

end
