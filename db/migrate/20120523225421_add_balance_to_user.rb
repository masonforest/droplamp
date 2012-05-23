class AddBalanceToUser < ActiveRecord::Migration
  def change
    add_column :users, :balance, :integer, :default => 0
  end
end
