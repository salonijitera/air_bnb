class User < ApplicationRecord
  has_many :wish_lists, foreign_key: :user_id, class_name: 'WishList'
  has_many :notifications, foreign_key: :user_id, class_name: 'Notification'
  has_many :premium_listings, foreign_key: :user_id, class_name: 'PremiumListing'
  validates :name, :email, presence: true
end
