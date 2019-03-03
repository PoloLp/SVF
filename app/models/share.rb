class Share < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_one :category
  scope :asc_review, -> {
    includes(:reviews).order('reviews.created_at ASC')
  }
end
