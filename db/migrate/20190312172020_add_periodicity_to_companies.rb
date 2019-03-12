class AddPeriodicityToCompanies < ActiveRecord::Migration[5.2]
  def change
    # add_column t.references :periodicity, foreign_key: true
    add_reference :companies, :periodicity, index: true
  end
end
