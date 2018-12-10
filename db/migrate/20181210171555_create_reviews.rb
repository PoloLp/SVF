class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.text :investment_strategy
      t.text :current_strategy
      t.references :share, foreign_key: true

      t.timestamps
    end
  end
end
