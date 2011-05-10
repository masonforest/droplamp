class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites do |t|
      t.string :dropbox_token
      t.string :path
      t.string :domain
      t.string :subdomain
      t.timestamps
    end
  end

  def self.down
    drop_table :sites
  end
end
