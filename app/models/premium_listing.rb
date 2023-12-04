class PremiumListing < ApplicationRecord
  belongs_to :user
  validates :listing_name, :listing_status, :title, :description, :price, :status, :posted_date, :user_id, presence: true
end
