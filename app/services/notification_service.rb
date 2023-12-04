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
end
