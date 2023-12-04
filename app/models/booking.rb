class Booking < ApplicationRecord
  belongs_to :listing,
    foreign_key: :listing_id,
    class_name: 'Listing'
  belongs_to :user,
    foreign_key: :user_id,
    class_name: 'User'
  validates :user_id, :listing_id, presence: true, numericality: { only_integer: true }
  validates :start_date, :end_date, presence: true
  validate :date_from_must_be_before_date_to
  validates_date :start_date, :end_date
  def self.book_property(user_id, property_id, date_from, date_to)
    user = User.find_by(id: user_id)
    return { error: 'This user is not found' } unless user
    property = Listing.find_by(id: property_id)
    return { error: 'This property is not found' } unless property
    return { error: 'Property is not available' } unless property.availability
    booking = self.new(user_id: user_id, listing_id: property_id, start_date: date_from, end_date: date_to)
    if booking.valid?
      booking.save
      property.update(availability: false)
      { status: 200, booking: booking }
    else
      { error: booking.errors.full_messages }
    end
  end
  private
  def date_from_must_be_before_date_to
    if start_date && end_date && start_date > end_date
      errors.add(:start_date, "The start date cannot be after the end date.")
    end
  end
end
