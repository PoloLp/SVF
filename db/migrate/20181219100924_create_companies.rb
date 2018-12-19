class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :logo_path
      t.boolean :status

      t.timestamps
    end
  end
end
