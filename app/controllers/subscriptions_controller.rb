class SubscriptionsController < ApplicationController
  def new
    @subscription = Subscription.new
    @subscription.site = Site.find(params[:site_id])
  end
  def create
    @subscription = Subscription.new(params[:subscription])
    if @subscription.save_with_payment
      @site = @subscription.site
      @site.create_heroku_domain
      @site.create_dropbox_folder
      flash[:notice] = render_to_string :partial=>"sites/welcome_message"
      redirect_to sites_path
    else
      render :new
    end
  end
  
end
