class Api::RegistrationsController < ApplicationController
  def create
    @user = User.new(user_params)
    if @user.valid?
      existing_user = User.find_by_email(@user.email)
      if existing_user.nil?
        @user.password = BCrypt::Password.create(@user.password)
        @user.save
        ApplicationMailer.confirmation_email(@user).deliver_now
        render json: { user: @user, confirmation_status: 'Email sent, please confirm your email address' }, status: 201
      else
        render json: { error: 'Email already registered' }, status: 400
      end
    else
      render json: { error: 'Invalid user data' }, status: 400
    end
  end
  private
  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
