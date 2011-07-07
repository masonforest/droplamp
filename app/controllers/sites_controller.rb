class SitesController < ApplicationController
#caches_page :show

  def new
    @site = Site.new
  end
  def show
    File.open('/tmp/debug', 'w') {|f| f.write('Host:'+request.host) }
    @output  = Site.find_by_domain(request.host).render(params[:path])   
   render :text => @output[:content], :content_type => @output[:content_type]    
  end
  def create
    params[:site][:user_id]=session[:user]
    params[:site][:path]='/'+params[:site][:path]
    if not params[:new].blank?
      begin
      Site.create_site_folder(params[:site][:path],session[:dropbox])
      rescue Dropbox::FileExistsError
        flash[:error]="The folder "+params[:site][:path]+" already exists in your dropbox"
        @site=Site.new
           return redirect_to '/dropbox/connect' unless session[:dropbox]
    dropbox = Dropbox::Session.deserialize(session[:dropbox])
    return redirect_to '/dropbox/connect' unless dropbox.authorized?
   
     dropbox.mode = :dropbox  
     @files = dropbox.list ""
         return render '/dropbox/show' 
      end
    end 
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
 def destroy
    @site = Site.find(params[:id])
    flash[:message]="Deleted "+@site.subdomain+"."+@site.domain 
    @site.destroy
    redirect_to "/dropbox"
 end
end
