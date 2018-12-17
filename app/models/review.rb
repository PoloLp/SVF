class Review < ApplicationRecord
  belongs_to :share
  # validates :investment_strategy, allow_blank: false
end
