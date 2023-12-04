# == Schema Information
#
# Table name: bookings
#
#  id         :bigint           not null, primary key
#  start_date :date
#  end_date   date
#  num_guests :integer
#  listing_id :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Booking < ApplicationRecord
  belongs_to :listing,
    foreign_key: :listing_id,
    class_name: 'Listing'
  belongs_to :user,
    foreign_key: :user_id,
    class_name: 'User'
  def self.book_property(user_id, property_id)
    user = User.find_by(id: user_id)
    return { error: 'User not found' } unless user
    property = Listing.find_by(id: property_id)
    return { error: 'Property not found' } unless property
    return { error: 'Property is not available' } unless property.availability
    booking = self.create(user_id: user_id, listing_id: property_id)
    property.update(availability: false)
    { success: 'Booking successful', booking: booking }
  end
end
