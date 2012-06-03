class AddStoredStripeCardToUser < ActiveRecord::Migration
  def change
    add_column :users, :stored_stripe_card, :boolean, :default => false
  end
end
