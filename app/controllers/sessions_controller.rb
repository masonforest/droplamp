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
      @site = Site.new(ActiveSupport::JSON.decode(session[:site]).merge( owner_id: user.id, dropbox_folder: dropbox_folder ))
      if @site.save
        if @site.domain.free? 
          flash[:notice] = render_to_string :partial=>"sites/welcome_message"
          redirect_to sites_path
        else
          redirect_to new_subscription_path( site_id: @site.id )
        end
      else
        render :edit
      end
    end
    
  end
 def failure
    redirect_to root_url, :alert => "Authentication error: #{params[:message].humanize}"
  end
 def new
    redirect_to "/auth/#{config['provider']}"
  end

end
