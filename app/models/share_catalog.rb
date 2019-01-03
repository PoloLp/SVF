class ShareCatalog < ApplicationRecord
  belongs_to :share
  belongs_to :company

  validates :company_id, uniqueness: { scope: :share_id }
end
