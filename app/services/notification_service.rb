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
  private
  def send_wishlist_collaborator_notification(wish_list)
    message = "You have been added as a collaborator to the wish list #{wish_list.name}"
    notification = Notification.create(user_id: @user.id, message: message, status: 'unread', title: 'Wishlist Collaboration')
    # Assuming we have a mailer setup
    UserMailer.with(user: @user, wish_list: wish_list, notification: notification).collaborator_notification_email.deliver_later
  end
end
