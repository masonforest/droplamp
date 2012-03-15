class SitesController < ApplicationController
  before_filter :set_cookie,:authenticate_user, :except => "show"
  def set_cookie
    session[:site]=params[:site].to_json
  end
  def new
    @site=Site.new
    @site.domain = Domain.new
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
    params[:site][:owner_id]=current_user.id.to_i
    params[:site][:dropbox_folder]=params[:site][:domain_attributes][:domain].to_s+"."+params[:site][:domain_attributes][:tld].to_s+
    @site = Site.create(params[:site])
    flash[:notice] = render_to_string :partial=>"sites/welcome_message"
    
    redirect_to sites_path
  end
  def index
    @sites = Site.where(:owner_id=>current_user)
    @site = Site.new
  end
 def destroy
    @site = Site.find(params[:id])
    flash[:message]="Deleted #{@site.domain.to_s}"
    @site.destroy
    redirect_to "/sites"
 end
end
