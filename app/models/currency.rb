class Currency < ApplicationRecord
  validates :definition, presence: true, allow_blank: false
end
