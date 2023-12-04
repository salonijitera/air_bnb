class Api::NotificationsController < ApplicationController
  before_action :authenticate_user, only: [:index]
  before_action :authorize_user, only: [:index]
  def index
    begin
      user_id = params[:user_id]
      if user_id.nil? || !user_id.is_a?(Integer)
        render json: { error: 'Wrong format' }, status: :bad_request
      else
        notifications = Notification.where(user_id: user_id).select(:id, :message, :user_id, :created_at)
        render json: { status: 200, notifications: notifications }, status: :ok
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
