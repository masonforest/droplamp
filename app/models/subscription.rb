class Subscription < ActiveRecord::Base
  attr_accessor :stripe_card_token
  belongs_to :site
  after_create :charge_for_signup
  MONTHLY_PRICE=1000
  SIGNUP_PRICE=1000
  SIGNUP_PRICE_WITH_REFFERAL=500
  REFFERAL_BOUNTY=500

  def charge_for_signup
    if site.owner.reffered_by.present? and site.owner.subscriptions.count == 1
      site.owner.charge SIGNUP_PRICE_WITH_REFFERAL
      site.owner.reffered_by.credit REFFERAL_BOUNTY
    else
      site.owner.charge SIGNUP_PRICE
    end
  end

  def charge_monthly
    Stripe::Charge.create(
        :amount => monthly_price, # in cents
        :currency => "usd",
        :customer => site.owner.stripe_customer_id
    )
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end

  def monthly_price
    MONTHLY_PRICE
  end
  
  def signup_price
    if site.owner.reffered_by.present? and site.owner.subscriptions.count == 0
      SIGNUP_PRICE_WITH_REFFERAL
    else
      SIGNUP_PRICE
    end
  end


 # def save_with_payment
 #   if valid?
 #     customer = Stripe::Customer.create(description: site.owner.email, plan: plan_id, card: stripe_card_token)
 #     self.stripe_customer_token = customer.id
 #     save!
 #   end
 # rescue Stripe::InvalidRequestError => e
 #   logger.error "Stripe error while creating customer: #{e.message}"
 #   errors.add :base, "There was a problem with your credit card."
 #   false
 # end

end
