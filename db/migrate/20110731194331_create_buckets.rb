class CreateBuckets < ActiveRecord::Migration
  def self.up
    create_table :buckets do |t|
      t.string :name
      t.references :site
      t.timestamps
    end
  end

  def self.down
    drop_table :buckets
  end
end
