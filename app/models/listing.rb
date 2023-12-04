class Listing < ApplicationRecord
  # validates :title, :description, :num_guests, :type, :num_beds, :num_baths, :price, :self_check_in, :parking, :kitchen, :washer, :dryer, :dishwasher, :wifi, :tv, :bathroom_essentials, :bedroom_comforts, :coffee_maker, :hair_dryer, :location, :location_description, :lat, :long, :host_id, presence: true
  has_many_attached :photos
  has_many_attached :thumbnails
  has_many :reviews,
    foreign_key: :listing_id,
    class_name: 'Review'
  belongs_to :host,
    foreign_key: :host_id,
    class_name: 'User'
  has_many :reviewers,
    through: :reviews,
    source: :user
  has_many :bookings,
    foreign_key: :listing_id,
    class_name: 'Booking'
  def self.in_bounds(bounds)
    bounds = JSON.parse(bounds)
    self.where('lat < ?', bounds["northEast"]["lat"].to_f)
      .where('lat >?', bounds["southWest"]["lat"].to_f)
      .where('long < ?', bounds["northEast"]["lng"].to_f)
      .where('long > ?', bounds["southWest"]["lng"].to_f)
  end
  def average_rating
    rating_total = 0
    count = 0
    if self.reviews
      self.reviews.each do |review|
        rating_total += review.rating
        count += 1
      end
    end
    '%.2f' % (rating_total.to_f / count).round(2)
  end
  def num_reviews
    self.reviews.count.to_s
  end
  def book_property(user_id, property_id)
    user = User.find_by(id: user_id)
    return { error: 'User not found' } unless user
    property = Property.find_by(id: property_id)
    return { error: 'Property not found' } unless property
    return { error: 'Property is not available' } unless property.availability == 'available'
    booking = Booking.create(user_id: user_id, property_id: property_id)
    property.update(availability: 'booked')
    { success: 'Property booked successfully', booking: booking }
  end
end
