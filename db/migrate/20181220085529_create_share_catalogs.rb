class CreateShareCatalogs < ActiveRecord::Migration[5.2]
  def change
    create_table :share_catalogs do |t|
      t.references :share, foreign_key: true, presence: true
      t.references :company, foreign_key: true, presence: true

      t.timestamps
    end
  end
end
