class SitesController < ApplicationController
#caches_page :show
  before_filter :authenticate_user, :except => "show"
  def new
    @site = Site.new
    @site.domain = Domain.new
  end
  def activate
    @site = Site.find(params[:id])
    flash[:message] = render_to_string :partial=>"sites/welcome_message"
    redirect_to sites_path
  end
  def show
    puts "hey"
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
      if @site.domain.tld == "kissr.co"
        flash[:message] = render_to_string :partial=>"sites/welcome_message"
        redirect_to '/sites'
      else
        redirect_to "https://kissr-test.recurly.com/subscribe/domain_preregistered/#{@site.id}?first_name=#{@site.user.first_name}&last_name=#{@site.user.last_name}"
      end
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
    flash[:message]="Deleted #{@site.domain}"
    @site.destroy
    redirect_to "/sites"
 end
end
