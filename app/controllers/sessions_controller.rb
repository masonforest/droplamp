class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    puts "creating with #{auth}"
    logger.debug auth
    user = User.where(:provider => auth['provider'], 
                      :uid => auth['uid'].to_s).first|| User.create_with_omniauth(auth)
    session[:user_id]=user.id
    if not session[:site] == "null"
      @site = 
      puts "creating #{ActiveSupport::JSON.decode(session[:site]).merge( owner_id: user.id)}"
      domain = JSON.parse(session[:site])["domain_attributes"]
      dropbox_folder = domain["domain"].to_s+"."+domain["tld"].to_s
      @site = Site.create(ActiveSupport::JSON.decode(session[:site]).merge( owner_id: user.id, dropbox_folder: dropbox_folder ))
      puts @site.errors.inspect
      flash[:notice] = render_to_string :partial=>"sites/welcome_message"
    end
    
    redirect_to sites_path
  end
 def failure
    redirect_to root_url, :alert => "Authentication error: #{params[:message].humanize}"
  end
 def new
    redirect_to "/auth/#{config['provider']}"
  end

end
