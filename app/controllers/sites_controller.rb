class SitesController < ApplicationController
  def new
    @site = Site.new
  end
  def create
    puts "Created "+ session[:dropbox]
    params[:site][:dropbox_token]=session[:dropbox]
    @site = Site.new(params[:site])
    if @site.save
      redirect_to '/dropbox'
    end
  end
  def index
    return redirect_to '/dropbox/connect' unless session[:dropbox]
    dropbox = Dropbox::Session.deserialize(session[:dropbox])
    return redirect_to '/dropbox/connect' unless dropbox.authorized?
   
     dropbox.mode = :dropbox  
     @files = dropbox.list ""
  end
end
