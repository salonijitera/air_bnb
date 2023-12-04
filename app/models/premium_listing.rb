class PremiumListing < ApplicationRecord
  validates :listing_name, :listing_status, presence: true
end
