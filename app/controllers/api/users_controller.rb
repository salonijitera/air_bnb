class Api::UsersController < ApplicationController
  before_action :authorize, only: [:update, :create_profile, :update_profile]
  before_action :set_user, only: [:update, :create_profile, :update_profile]
  before_action :validate_params, only: [:update]
  before_action :validate_profile_params, only: [:create_profile, :update_profile]
  def register
    @user = User.new(user_params)
    if @user.valid?
      existing_user = User.find_by_email(user_params[:email])
      if existing_user
        render json: { error: 'Email is already registered' }, status: 400
      else
        @user.password = BCrypt::Password.create(user_params[:password])
        if @user.save
          ApplicationMailer.confirmation_email(@user).deliver_now
          render json: { status: 200, user: { id: @user.id, username: @user.username, email: @user.email, created_at: @user.created_at } }, status: 201
        else
          render json: { error: 'Failed to register user' }, status: 400
        end
      end
    else
      render json: { error: 'Invalid user parameters' }, status: 400
    end
  end
  private
  def user_params
    params.require(:user).permit(:username, :password, :email)
  end
end
