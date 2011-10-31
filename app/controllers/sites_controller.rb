class SitesController < ApplicationController
 # before_filter :authenticate_user, :except => "show"
  def new
    @site = Site.new
    render 'edit'
  end
  def edit
    @site = Site.find(params[:id])
  end
  def activate
    @site = Site.find(params[:id])
    flash[:message] = render_to_string :partial=>"sites/welcome_message"
    redirect_to sites_path
  end
  def show
    @site  = Site.find_by_domain(request.host)
    if @site then
      begin
        @output=@site.render(params[:path])
        render :text => @output, :content_type => "text/html"
      rescue Dropbox::UnsuccessfulResponseError => error
      render "404", status => 404
      end
      else
      render "missing", status => 404
    end
  end
  def create
    params[:site][:owner_id]=current_user.id
    params[:site][:path]=params[:site][:path]
    params[:site][:hostname]=params[:domain][:domain]+"."+params[:domain][:tld]
   @site = Site.new(params[:site])
    if @site.save
      if params[:domain][:tld] == "kissr.co"
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
    @sites = Site.where(:owner_id=>current_user)
    @site = Site.new
  end
 def destroy
    @site = Site.find(params[:id])
    flash[:message]="Deleted #{@site.hostname}"
    @site.destroy
    redirect_to "/sites"
 end
end
