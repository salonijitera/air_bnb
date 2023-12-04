class Api::UsersController < ApplicationController
  before_action :authorize, only: [:update]
  before_action :set_user, only: [:update]
  before_action :validate_params, only: [:update]
  def update
    if @user.update(user_params)
      render json: { status: 200, user: @user }, status: 200
    else
      render json: { message: 'Failed to update profile', errors: @user.errors.full_messages }, status: 500
    end
  end
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
  def set_user
    @user = User.find_by(id: params[:id])
    return render json: { message: 'This user is not found' }, status: 404 unless @user
    return render json: { message: 'User is not authenticated' }, status: 401 unless current_user
    return render json: { message: 'User does not have permission to access the resource' }, status: 403 unless current_user.id == @user.id
  end
  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
  def authorize
    return render json: { message: 'User is not authenticated' }, status: 401 unless current_user
  end
  def validate_params
    return render json: { message: 'Wrong format' }, status: 422 unless params[:id].is_a?(Integer)
    return render json: { message: 'The name is required.' }, status: 422 if params[:name].blank?
    return render json: { message: 'The email is required.' }, status: 422 if params[:email].blank?
    return render json: { message: 'The email is not in valid format.' }, status: 422 unless params[:email] =~ URI::MailTo::EMAIL_REGEXP
  end
end
