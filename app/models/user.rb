class User < ApplicationRecord
  has_many :wish_lists, foreign_key: :user_id, class_name: 'WishList'
  has_many :notifications, foreign_key: :user_id, class_name: 'Notification'
  has_many :premium_listings, foreign_key: :user_id, class_name: 'PremiumListing'
  has_many :bookings, foreign_key: :user_id, class_name: 'Booking'
  validates :name, :email, :location, presence: true
  validates :is_vip, inclusion: { in: [true, false] }
end
