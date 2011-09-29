class SessionsController < ApplicationController
 def create
    puts 'aaaa'
    puts request.env
    auth = request.env["omniauth.auth"]
    user = User.where(:provider => auth['provider'], 
                      :uid => auth['uid'].to_s).first|| User.create_with_omniauth(auth)
    puts 'yep'
    puts user.inspect
    session[:user_id] = user.id
    puts 'even still'
    redirect_to new_site_path, :notice => 'Signed in!'
  end
 def failure
    redirect_to root_url, :alert => "Authentication error: #{params[:message].humanize}"
  end
 def new
    redirect_to "/auth/#{config['provider']}"
  end

end
