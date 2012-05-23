class AddRefferedByIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :reffered_by_id, :integer
  end
end
