class AddLayoutRevisionToPage < ActiveRecord::Migration
  def change
    add_column :pages, :layout_revision, :string
  end
end
