class AddStripeCusomterIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :stripe_customer_id, :string
    begin
      #User.all.map(&:create_stripe_user)
    rescue
    end
  end
end
