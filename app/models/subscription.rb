class Subscription < ActiveRecord::Base
  belongs_to :site
  attr_accessor :stripe_card_token, :plan_id


  def save_with_payment
    if valid?
      customer = Stripe::Customer.create(description: site.owner.email, plan: plan_id, card: stripe_card_token)
      self.stripe_customer_token = customer.id
      save!
    end
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    errors.add :base, "There was a problem with your credit card."
    false
  end

end
