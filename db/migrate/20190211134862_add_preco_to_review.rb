class AddPrecoToReview < ActiveRecord::Migration[5.2]
  def change
    add_reference :reviews, :preconisation, index: true
  end
end

