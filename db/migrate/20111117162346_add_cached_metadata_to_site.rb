class AddCachedMetadataToSite < ActiveRecord::Migration
  def change
    add_column :sites, :cached_metadata, :text
  end
end
