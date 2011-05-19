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
     user=User.find_or_create_by_dropbox_uid(dropbox.account.uid)
     user.dropbox_token=session[:dropbox]
    user.save
    session[:user]=user
      redirect_to dropbox_path
     else
       dropbox = Dropbox::Session.new('69vdq9pk8stjkb8', '6gc7j0bdw85uzohi')
       session[:dropbox] = dropbox.serialize
       redirect_to dropbox.authorize_url(:oauth_callback => url_for(:action => 'connect'))
     end
   end

end

