class Booking < ApplicationRecord
  belongs_to :user, foreign_key: :user_id, class_name: 'User'
  belongs_to :property, foreign_key: :property_id, class_name: 'Property'
  validates :user_id, :property_id, :date, :is_premium, presence: true
  validates :user_id, :property_id, numericality: { only_integer: true }
  enum status: { pending: 0, confirmed: 1, cancelled: 2 }
  def available?
    property.availability
  end
  def confirm
    self.status = 'confirmed'
    self.save
    UserMailer.with(user: self.user).booking_confirmation_email.deliver_later
  end
  def self.book_property(user_id, property_id)
    user = User.find(user_id)
    property = Property.find(property_id)
    if property.availability
      booking = self.create(user_id: user.id, property_id: property.id, status: 'pending')
      booking.confirm
      return booking
    else
      return nil
    end
  end
end
