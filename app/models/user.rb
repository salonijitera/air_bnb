class User < ApplicationRecord
  has_many :wish_lists, foreign_key: :user_id, class_name: 'WishList'
  has_many :notifications, foreign_key: :user_id, class_name: 'Notification'
  has_many :premium_listings, foreign_key: :user_id, class_name: 'PremiumListing'
  has_many :bookings, foreign_key: :user_id, class_name: 'Booking'
  validates :name, :email, :location, :password, presence: true
  validates :is_vip, inclusion: { in: [true, false] }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  before_save :encrypt_password
  def email_registered?
    User.exists?(email: self.email)
  end
  def encrypt_password
    self.password = BCrypt::Password.create(self.password)
  end
  def register
    if self.valid? && !self.email_registered?
      self.save
      # Assuming that send_confirmation_email is a method that sends a confirmation email to the user
      self.send_confirmation_email
    end
  end
  def confirm_email
    self.update(confirmed: true)
  end
end
