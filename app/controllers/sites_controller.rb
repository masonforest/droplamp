class SitesController < ApplicationController
 # before_filter :authenticate_user, :except => "show"
  def new
    @site = Site.new
    render 'edit'
  end
  def edit
    @site = Site.find(params[:id])
  end
  def update
    @site = Site.find(params[:id])
    @site.update_attributes(params[:site])
    redirect_to sites_path, notice: 'Site was successfully updated.'
  end
  def create
    puts "Createing site for user ID:#{current_user.id}"
    params[:site][:owner_id]=current_user.id
    params[:site][:hostname]=params[:site][:hostname]+"."+params[:hostname][:suffix]
   @site = Site.new(params[:site])
    if @site.save
      if params[:hostname][:suffix] == "kissr.co"
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
