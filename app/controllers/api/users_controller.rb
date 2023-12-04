class Api::UsersController < ApplicationController
  # Other methods...
  def register
    user = User.new(user_params)
    if user.valid?
      existing_user = User.find_by_email(user.email)
      if existing_user
        render json: { error: 'Email already registered' }, status: 400
      else
        user.password = BCrypt::Password.create(user.password)
        user.save!
        UserMailer.with(user: user).confirmation_email.deliver_now
        render json: { status: 200, user: user.slice(:id, :name, :email), message: 'Registration successful, confirmation email sent' }, status: 200
      end
    else
      error_message = user.errors.full_messages.join(", ")
      render json: { error: error_message }, status: 422
    end
  rescue => e
    render json: { error: e.message }, status: 500
  end
  private
  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
