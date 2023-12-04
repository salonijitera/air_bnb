class Api::NotificationsController < ApplicationController
  before_action :authenticate_user, only: [:index, :get_notifications]
  before_action :authorize_user, only: [:index, :get_notifications]
  def index
    begin
      user_id = params[:user_id].to_i
      if user_id.nil? || !user_id.is_a?(Integer)
        render json: { error: 'Wrong format' }, status: :bad_request
      else
        user = User.find_by(id: user_id)
        if user.nil?
          render json: { error: 'This user is not found' }, status: :not_found
        else
          notifications = Notification.where(user_id: user_id)
          if notifications.empty?
            render json: { error: 'No notifications found for this user' }, status: :not_found
          else
            notifications.each do |notification|
              notification.update(status: 'read')
            end
            render json: { status: 200, notifications: notifications.as_json(only: [:id, :message, :status, :user_id]) }, status: :ok
          end
        end
      end
    rescue => e
      render json: { error: 'An unexpected error occurred' }, status: :internal_server_error
    end
  end
  def get_notifications
    begin
      user_id = params[:user_id].to_i
      if user_id.nil? || !user_id.is_a?(Integer)
        render json: { error: 'Wrong format' }, status: :bad_request
      else
        notifications = NotificationService.get_notifications(user_id)
        if notifications.empty?
          render json: { error: 'No notifications found for this user' }, status: :not_found
        else
          render json: { status: 200, notifications: notifications.as_json(only: [:id, :message, :status, :user_id]) }, status: :ok
        end
      end
    rescue => e
      render json: { error: 'An unexpected error occurred' }, status: :internal_server_error
    end
  end
  private
  def authenticate_user
    # Add your authentication logic here
  end
  def authorize_user
    # Add your authorization logic here
  end
end
