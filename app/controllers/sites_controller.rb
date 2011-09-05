class SitesController < ApplicationController
#caches_page :show

  def new
    @site = Site.new
    @site.domain = Domain.new
  end
  def show
    #response.headers['Cache-Control'] = 'public, max-age=300'
    @site  = Site.find_by_domain(request.host)
    if @site then
      @output=@site.render(params[:path])
      render :text => @output, :content_type => "text/html"
    else
      render "missing", status => 404
    end
  end
  def create
    params[:site][:user_id]=current_user.id
    params[:site][:path]=params[:site][:path]
   @site = Site.new(params[:site])
    if @site.save
      flash[:message] = render_to_string :partial=>"sites/welcome_message"
      redirect_to '/sites'
    else
      render 'new'
    end
  end
  def index
    @sites = Site.where(:user_id=>current_user)
    @site = Site.new
  end
 def destroy
    @site = Site.find(params[:id])
    flash[:message]="Deleted "+@site.subdomain+"."+@site.domain 
    @site.destroy
    redirect_to "/dropbox"
 end
end
