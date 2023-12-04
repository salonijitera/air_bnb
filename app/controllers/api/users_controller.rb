class Api::UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    if @user.valid?
      existing_user = User.find_by(email: @user.email)
      if existing_user.nil?
        @user.save
        UserMailer.confirmation_email(@user).deliver_now
        render json: { id: @user.id, name: @user.name, email: @user.email, location: @user.location }, status: :created
      else
        render json: { error: 'Email already registered' }, status: :unprocessable_entity
      end
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end
  private
  def user_params
    params.require(:user).permit(:name, :email, :location)
  end
end
