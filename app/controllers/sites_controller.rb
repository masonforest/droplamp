class SitesController < ApplicationController
  before_filter :set_cookie,:authenticate_user, :except => "show"
  def set_cookie
    session[:site]=params[:site].to_json
  end
  def new
    @site = Site.new
    render 'edit'
  end
  def edit
    @site = Site.find(params[:id])
  end
  def refresh
    @site = Site.find(params[:id])
    @site.refresh
    redirect_to sites_path, notice: "Refreshing #{@site.hostname}"
  end
  def update
    @site = Site.find(params[:id])
    @site.update_attributes(params[:site])
    redirect_to sites_path, notice: 'Site was successfully updated.'
  end
  def create
    puts "Createing site for user ID:#{current_user.id}"
    params[:site][:owner_id]=current_user.id.to_i
    @site = Site.new(params[:site])
    if @site.save
      if params[:hostname][:suffix] == "droplamp.com"
        flash[:message] = render_to_string :partial=>"sites/welcome_message"
        redirect_to '/sites'
      else
        redirect_to "https://kissr-test.recurly.com/subscribe/domain_preregistered/#{@site.id}?first_name=#{@site.user.first_name}&last_name=#{@site.user.last_name}"
      end
    else
      render 'edit'
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
