class NotificationService
  def initialize(user_id)
    raise 'Wrong format' unless user_id.is_a? Integer
    @user = User.find_by(id: user_id)
    raise 'This user is not found' unless @user
  end
  def create_premium_listing(listing_name, listing_status)
    raise 'Invalid input' unless listing_name.is_a?(String) && PremiumListing.statuses.include?(listing_status)
    premium_listing = PremiumListing.create(name: listing_name, status: listing_status, user_id: @user.id)
    if premium_listing.persisted?
      send_premium_listing_creation_notification(premium_listing)
      return premium_listing.id
    else
      raise 'Failed to create premium listing'
    end
  end
  def send_premium_listing_creation_notification(premium_listing)
    message = "Premium listing with id #{premium_listing.id} has been successfully created"
    notification = Notification.create(user_id: @user.id, message: message, status: 'unread', title: 'Premium Listing Creation')
    # Assuming we have a mailer setup
    UserMailer.with(user: @user, premium_listing: premium_listing, notification: notification).premium_listing_creation_notification_email.deliver_later
  end
  def send_confirmation_email(email)
    raise 'Invalid email' unless email.is_a?(String)
    UserMailer.with(user: @user).confirmation_email.deliver_later
    return 'Email sent successfully'
  end
  # ... rest of the class
end
