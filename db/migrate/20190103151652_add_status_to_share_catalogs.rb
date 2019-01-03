class AddStatusToShareCatalogs < ActiveRecord::Migration[5.2]
  def change
    add_column :share_catalogs, :status, :boolean, null: false, default: false
  end
end
