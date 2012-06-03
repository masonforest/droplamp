class SubscriptionsController < ApplicationController
  def new
    @subscription = Subscription.new
    @subscription.site = Site.find(params[:site_id])
  end
  def create
    @subscription = Subscription.new(params[:subscription])
    current_user.update_stripe_card(params[:subscription][:stripe_card_token]) unless current_user.stored_stripe_card
    if @subscription.save
      @subscription.site.create_dropbox_folder
      @subscription.site.create_heroku_domain
      @site = @subscription.site
      flash[:notice] = render_to_string :partial=>"sites/welcome_message"
      redirect_to sites_path
    else
      render :new
    end
  end
  
end
