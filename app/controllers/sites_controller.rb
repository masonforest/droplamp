class SitesController < ApplicationController
  def new
    @site = Site.new
  end
  def show
    @output  = Site.find_by_domain(request.host).render(params[:path])     
    render :text => @output[:content], :content_type => @output[:content_type]    
  end
  def create
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
