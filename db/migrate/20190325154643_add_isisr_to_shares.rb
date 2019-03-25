class AddIsisrToShares < ActiveRecord::Migration[5.2]
  def change
    add_column :shares, :isisr, :boolean, default: false
  end
end
