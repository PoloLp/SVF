class Company < ApplicationRecord
  has_many :users

  validates :name, length: { minimum: 3 }, presence: true
end
