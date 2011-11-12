class RenamePathToDropboxFolder < ActiveRecord::Migration
  def change
    rename_column :sites, :path, :dropbox_folder
  end
end
