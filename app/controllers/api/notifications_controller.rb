class Api::NotificationsController < ApplicationController
  before_action :authenticate_user, only: [:index, :get_notifications]
  before_action :authorize_user, only: [:index, :get_notifications]
  def register
    begin
      name = params[:name]
      email = params[:email]
      password = params[:password]
      user = User.new(name: name, email: email, password: password)
      if user.valid?
        existing_user = User.find_by(email: email)
        if existing_user
          render json: { error: 'Email already exists' }, status: :bad_request
        else
          user.password = BCrypt::Password.create(password)
          user.save!
          NotificationService.new(user).send_confirmation_email
          render json: { status: 200, user: user.as_json(only: [:id, :name, :email]), confirmation_status: 'Email sent' }, status: :ok
        end
      else
        render json: { error: 'Invalid data' }, status: :bad_request
      end
    rescue => e
      render json: { error: 'An unexpected error occurred' }, status: :internal_server_error
    end
  end
  def index
    # existing code
  end
  def get_notifications
    # existing code
  end
  private
  def authenticate_user
    # existing code
  end
  def authorize_user
    # existing code
  end
end
