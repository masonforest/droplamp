 class DropboxController < ApplicationController
   def show
    @site = Site.new
    return redirect_to '/dropbox/connect' unless session[:dropbox]
    dropbox = Dropbox::Session.deserialize(session[:dropbox])
    return redirect_to '/dropbox/connect' unless dropbox.authorized?
   
     dropbox.mode = :dropbox  
     @files = dropbox.list ""
  end
  def connect
     if params[:oauth_token] then
       dropbox = Dropbox::Session.deserialize(session[:dropbox])
     dropbox.mode = :dropbox  
      dropbox.authorize(params)
        session[:dropbox] = dropbox.serialize # re-serialize the authenticated session

       redirect_to dropbox_path
     else
       dropbox = Dropbox::Session.new('umiao80thn4qqqf', 'bs076zkmeeuxy1o')
       session[:dropbox] = dropbox.serialize
       redirect_to dropbox.authorize_url(:oauth_callback => url_for(:action => 'connect'))
     end
   end

end

