class Api::NotificationsController < ApplicationController
  before_action :authenticate_user, only: [:get_notifications, :index]
  before_action :authorize_user, only: [:get_notifications, :index]
  def get_notifications
    begin
      user_id = params[:user_id].to_i
      if user_id <= 0
        render json: { error: 'Wrong format' }, status: :unprocessable_entity
      else
        user = User.find_by(id: user_id)
        if user.nil?
          render json: { error: 'This user is not found' }, status: :bad_request
        else
          notifications = Notification.where(user_id: user_id).select(:id, :message, :status, :created_at)
          render json: { status: 200, notifications: notifications }, status: :ok
        end
      end
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
  def index
    begin
      user_id = params[:user_id].to_i
      if user_id <= 0
        render json: { error: 'Wrong format' }, status: :unprocessable_entity
      else
        user = User.find_by(id: user_id)
        if user.nil?
          render json: { error: 'This user is not found' }, status: :bad_request
        else
          notifications = Notification.where(user_id: user_id).select(:id, :message, :status, :created_at)
          render json: { status: 200, notifications: notifications }, status: :ok
        end
      end
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
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
