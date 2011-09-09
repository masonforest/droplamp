class AddPreregisteredToDomain < ActiveRecord::Migration
  def change
    add_column :domains, :preregistered, :boolean
  end
end
