class LocalExperienceService
  def initialize(user_id)
    raise 'Wrong format' unless user_id.is_a? Integer
    @user = User.find_by(id: user_id)
    raise 'This user is not found' unless @user
  end
  def create_local_experience(title, description, location, price, image, status)
    raise 'The title is required.' if title.blank?
    raise 'The description is required.' if description.blank?
    raise 'The location is not found.' unless Location.exists?(name: location)
    raise 'The price must be a number.' unless price.is_a?(Numeric)
    raise 'The status is not valid.' unless LocalExperience.statuses.include?(status)
    local_experience = LocalExperience.new(
      title: title, 
      description: description, 
      location: location, 
      price: price, 
      image: image, 
      status: status, 
      user_id: @user.id
    )
    if local_experience.save
      send_local_experience_creation_notification(local_experience)
      return {status: 200, local_experience: local_experience}
    else
      raise 'Failed to create local experience'
    end
  end
  def send_local_experience_creation_notification(local_experience)
    message = "Local experience with id #{local_experience.id} has been successfully created"
    notification = Notification.create(user_id: @user.id, message: message, status: 'unread', title: 'Local Experience Creation')
    # Assuming we have a mailer setup
    UserMailer.with(user: @user, local_experience: local_experience, notification: notification).local_experience_creation_notification_email.deliver_later
  end
end
