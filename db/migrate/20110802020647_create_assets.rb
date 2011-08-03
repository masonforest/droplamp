class CreateAssets < ActiveRecord::Migration
  def self.up
    create_table :assets do |t|
      t.references :page
      t.timestamps
    end
  end

  def self.down
    drop_table :assets
  end
end
