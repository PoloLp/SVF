class Share < ApplicationRecord
  has_many :reviews, dependent: :destroy
end
