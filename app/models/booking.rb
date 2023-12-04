class Booking < ApplicationRecord
  belongs_to :user, foreign_key: :user_id, class_name: 'User'
  validates :user_id, :date, :is_premium, presence: true
  validates :user_id, numericality: { only_integer: true }
  enum status: { pending: 0, confirmed: 1, cancelled: 2 }
  def available?
    user.availability
  end
  def confirm
    self.status = 'confirmed'
    self.save
    UserMailer.with(user: self.user).booking_confirmation_email.deliver_later
  end
  def self.book_user(user_id)
    user = User.find(user_id)
    if user.availability
      booking = self.create(user_id: user.id, status: 'pending')
      booking.confirm
      return booking
    else
      return nil
    end
  end
end
