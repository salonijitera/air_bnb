class Api::NotificationsController < ApplicationController
  def send_notifications(user_id)
    begin
      user = User.find(user_id)
      properties = Property.where('updated_at > ?', user.updated_at)
      properties.each do |property|
        Notification.create(user_id: user_id, message: "Property #{property.name} has been updated.")
      end
      render json: { message: 'Notifications sent successfully.' }, status: :ok
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end
end
