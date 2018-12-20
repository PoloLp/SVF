class Company < ApplicationRecord
  validates :name, uniqueness: true, length: { minimum: 3 }, presence: true
end
