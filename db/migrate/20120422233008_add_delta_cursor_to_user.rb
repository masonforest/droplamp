class AddDeltaCursorToUser < ActiveRecord::Migration
  def change
    add_column :users, :delta_cursor, :string
  end
end
