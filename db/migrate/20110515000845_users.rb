class Users < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :dropbox_token
      t.string :dropbox_uid
    end
   end

  def self.down
  drop_table :users  
 end
end
