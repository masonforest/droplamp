class SubscriptionsController < ApplicationController
  def new
    @subscription = Subscription.new
    @subscription.site = Site.find(params[:site_id])
  end
  def create
    @subscription = Subscription.new(params[:subscription])
    current_user.update_stripe_card(params[:subscription][:stripe_card_token])
    if @subscription.save
      redirect_to sites_path
    else
      render :new
    end
  end
  
end
