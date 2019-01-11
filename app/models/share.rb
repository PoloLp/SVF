class Share < ApplicationRecord
  has_many :reviews, dependent: :destroy

  scope :asc_review, -> {
    includes(:reviews).order('reviews.created_at ASC')
  }
end
