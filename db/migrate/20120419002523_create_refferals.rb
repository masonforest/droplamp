class CreateRefferals < ActiveRecord::Migration
  def change
    create_table :refferals do |t|
      t.references :from_user
      t.references :to_user

      t.timestamps
    end
    add_index :refferals, :from_user_id
    add_index :refferals, :to_user_id
  end
end
