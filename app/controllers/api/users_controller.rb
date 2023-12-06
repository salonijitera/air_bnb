class Api::UsersController < ApplicationController
  before_action :authorize, only: [:check_vip_status, :vip_status]
  def create
    @user = User.new(user_params)
    if @user.valid?
      existing_user = User.find_by(email: @user.email)
      if existing_user.nil?
        @user.password = BCrypt::Password.create(params[:password])
        @user.save
        NotificationService.new.send_confirmation_email(@user)
        render json: { id: @user.id, name: @user.name, email: @user.email, location: @user.location, confirmed: @user.confirmed }, status: :created
      else
        render json: { error: 'Email already registered' }, status: :unprocessable_entity
      end
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end
  def check_vip_status
    user = User.find_by(id: params[:user_id])
    if user.nil?
      render json: { error: 'User not found' }, status: :not_found
    else
      render json: { is_vip: user.is_vip }, status: :ok
    end
  end
  def vip_status
    user_id = params[:id]
    if user_id.is_a?(Integer)
      user = User.find_by(id: user_id)
      if user
        render json: { status: 200, user: { id: user.id, is_vip: user.is_vip } }, status: :ok
      else
        render json: { error: 'This user is not found' }, status: :not_found
      end
    else
      render json: { error: 'Wrong format' }, status: :bad_request
    end
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end
  def count_user_bookings
    user = User.find_by(id: params[:user_id])
    if user
      bookings_count = Booking.where(user_id: params[:user_id]).count
      eligible_for_premium = bookings_count >= 10
      render json: { bookings_count: bookings_count, eligible_for_premium: eligible_for_premium }
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end
  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :location)
  end
end
