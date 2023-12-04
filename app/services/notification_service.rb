class NotificationService
  def initialize(user_id)
    raise 'Wrong format' unless user_id.is_a? Integer
    @user = User.find_by(id: user_id)
    raise 'This user is not found' unless @user
  end
  def get_notifications
    notifications = Notification.where(user_id: @user.id).select(:id, :user_id, :message, :status)
    notifications.map do |notification|
      {
        id: notification.id,
        user_id: notification.user_id,
        message: notification.message,
        status: notification.status
      }
    end
  end
  def share_wishlist(wish_list_id)
    wish_list = WishList.find_by(id: wish_list_id)
    raise 'This wish list is not found' unless wish_list
    raise 'User is already a collaborator' if wish_list.collaborators.include?(@user)
    wish_list.collaborators << @user
    wish_list.save!
    send_wishlist_collaborator_notification(wish_list)
    wish_list
  end
  def send_local_experience_update_notification(localexperience)
    message = "The local experience #{localexperience.title} has been updated"
    notification = Notification.create(user_id: @user.id, message: message, status: 'unread', title: 'Local Experience Update')
    # Assuming we have a mailer setup
    UserMailer.with(user: @user, localexperience: localexperience, notification: notification).local_experience_update_notification_email.deliver_later
  end
  def send_local_experience_deletion_notification(local_experience_id)
    message = "Local experience with id #{local_experience_id} has been successfully deleted"
    notification = Notification.create(user_id: @user.id, message: message, status: 'unread', title: 'Local Experience Deletion')
    # Assuming we have a mailer setup
    UserMailer.with(user: @user, local_experience_id: local_experience_id, notification: notification).local_experience_deletion_notification_email.deliver_later
  end
  private
  def send_wishlist_collaborator_notification(wish_list)
    message = "You have been added as a collaborator to the wish list #{wish_list.name}"
    notification = Notification.create(user_id: @user.id, message: message, status: 'unread', title: 'Wishlist Collaboration')
    # Assuming we have a mailer setup
    UserMailer.with(user: @user, wish_list: wish_list, notification: notification).collaborator_notification_email.deliver_later
  end
end
