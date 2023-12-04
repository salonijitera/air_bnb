class PremiumListingService
  def initialize(user_id)
    raise 'Wrong format' unless user_id.is_a? Integer
    @user = User.find_by(id: user_id)
    raise 'This user is not found' unless @user
  end
  def create_premium_listing(title, description, price, status, posted_date)
    raise 'The title is required.' if title.blank?
    raise 'The description is required.' if description.blank?
    raise 'The price must be a number.' unless price.is_a?(Numeric)
    raise 'The status is not valid.' unless PremiumListing.statuses.include?(status)
    raise 'The posted_date is not a valid date.' unless posted_date.is_a?(Date)
    premium_listing = PremiumListing.create(title: title, description: description, price: price, status: status, posted_date: posted_date, user_id: @user.id)
    if premium_listing.persisted?
      send_premium_listing_creation_notification(premium_listing)
      return {status: 200, premium_listing: premium_listing}
    else
      raise 'Failed to create premium listing'
    end
  end
  def create_premium_listings
    vip_users = User.where(is_vip: true)
    premium_listings = []
    vip_users.each do |user|
      premium_listing = PremiumListing.create(user_id: user.id, listing_date: Date.today)
      premium_listings << {user_id: user.id, listing_date: premium_listing.listing_date} if premium_listing.persisted?
    end
    premium_listings
  end
  def delete_premium_listing(id)
    raise 'Wrong format' unless id.is_a? Integer
    premium_listing = PremiumListing.find_by(id: id)
    raise 'This premium listing is not found' unless premium_listing
    premium_listing.destroy
    return {status: 200, message: "Premium listing was successfully deleted."}
  end
  def send_premium_listing_creation_notification(premium_listing)
    message = "Premium listing with id #{premium_listing.id} has been successfully created"
    notification = Notification.create(user_id: @user.id, message: message, status: 'unread', title: 'Premium Listing Creation')
    # Assuming we have a mailer setup
    UserMailer.with(user: @user, premium_listing: premium_listing, notification: notification).premium_listing_creation_notification_email.deliver_later
  end
  # ... rest of the class
end
