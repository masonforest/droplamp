class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :site
      t.string :stripe_customer_token

      t.timestamps
    end
    add_index :subscriptions, :site_id
  end
end
