class AddInterlocuteurToReviews < ActiveRecord::Migration[5.2]
  def change
    add_column :reviews, :interlocuteur, :string
  end
end
