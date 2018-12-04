class CreateShares < ActiveRecord::Migration[5.2]
  def change
    create_table :shares do |t|
      t.string :isin
      t.string :secid
      t.string :performanceid
      t.string :fundid
      t.string :securityname
      t.string :company

      t.timestamps
    end
  end
end
